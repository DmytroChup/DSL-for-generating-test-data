require 'date'
require 'yaml'

module TestData
  class Entity
    attr_reader :attributes

    def initialize(&block)
      @attributes = {}
      instance_eval(&block) if block_given?
    end

    private

    def attribute(name, type, options = {})
      @attributes[name] = {type: type, options: options}
    end

    def method_missing(name, *args)
      case args.size
      when 2
        raise ArgumentError, "Second param should be a hash" unless args[1].is_a?(Hash)

        options = args[1]
        raise ArgumentError, "Hash should have only 1 key->value" unless options.size == 1

        option_key, option_value = options.first
        case option_key
        when :range
          raise ArgumentError, "Range should be a Range object" unless option_value.is_a?(Range)
          raise ArgumentError, "Invalid range provided" if option_value.first.class != option_value.last.class
        when :length
          raise ArgumentError, "Length should be a positive integer" unless option_value.is_a?(Integer) && option_value.positive?
        when :array
          raise ArgumentError, "Array should be a non-empty array" unless option_value.is_a?(Array) && !option_value.empty?
        when :path
          raise ArgumentError, "Path should be a non-empty string" unless option_value.is_a?(String) && !option_value.empty?
        else
          raise ArgumentError, "Invalid option key: #{option_key}"
        end

        attribute(name, args[0], args[1])
      else
        raise ArgumentError, "Should be 2 args"
      end
    end
  end

  class Generator
    def self.number(range)
      rand(range)
    end

    def self.string(length)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a
      length.times.map { chars.sample }.join
    end

    def self.date(range)
      Time.at(rand(range.first.to_time.to_i..range.last.to_time.to_i)).to_date
    end

    def self.choice(array)
      array.sample
    end

    def self.email(length)
      string(length) + "@example.com"
    end

    def self.yml(path)
      data = YAML.load_file(path)
      data.values.flatten.sample
    end

    def self.generate(type, options = {})
      case type
      when :number
        number(options[:range] || (1..100))
      when :string
        string(options[:length] || 10)
      when :date
        date(options[:range] || (Date.today..Date.today + 30))
      when :choice
        choice(options[:array] || [])
      when :email
        email(options[:length] || 10)
      when :yml
        yml(options[:path] || '/')
      else
        raise "Unknown type: #{type}"
      end
    end
  end

  def self.entity(&block)
    Entity.new(&block)
  end

  def self.generate(entity, count = 1)
    count.times.map do
      entity.attributes.map do |name, info|
        [name, Generator.generate(info[:type], info[:options])]
      end.to_h
    end
  end
end
