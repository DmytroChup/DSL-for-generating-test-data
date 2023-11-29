# TestData Module

This code defines a `TestData` module that includes classes for generating test data. The module consists of two classes: `Entity` and `Generator`, along with some helper methods.

## TestData::Entity

- `initialize(&block)`: The `Entity` class is created using a block that defines various attributes that the user can come up with himself, based on the specified types and parameters.
- `attribute(name, type, options = {})`: Private method within `Entity` used to define attributes with specified types and options.

## TestData::Generator

This class contains several methods for generating specific types of data:

- `number(range)`: Generates a random number within the specified range.
- `string(length)`: Creates a random string based on specific length constraints.
- `date(range)`: Generates a random date within the specified range.
- `choice(array)`: Selects a random element from the provided array.
- `email(length)`: Generates a random email address.
- `yml(path)`: Loads YAML data from a file and randomly selects an item from the loaded data.
- `generate(type, options = {})`: Generates data based on the specified type and additional options.

## Usage

The usage example demonstrates how to define an entity with specific attributes using the `TestData.entity` method and generate test data for that entity with the `TestData.generate` method.

```ruby
require 'date'
require 'yaml'
require_relative 'test_data'

user = TestData.entity do
  name :string, length: 5
  age :number, range: 18..65
  birth_date :date, range: Date.new(1950, 1, 1)..Date.new(2005, 12, 31)
  gender :choice, array: %w[male female other]
  dad_name :string, length: 10
  email :email, length: 3
  animal :yml, path: "yml/animal.yml"
end

users = TestData.generate(user, 5)

puts users
