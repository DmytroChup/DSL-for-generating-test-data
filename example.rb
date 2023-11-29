require_relative 'test_data'

user = TestData.entity do
  name :string, length: 5
  age :number, range: 18..65
  birth_date :date, range: Date.new(1950, 1, 1)..Date.new(2005, 12, 31)
  gender :choice, array: %w[male female other]
  dad_name :string, length: 10
  email :email, length: 1
  animal :yml, path: "yml/animal.yml"
end

users = TestData.generate(user, 5)

puts users