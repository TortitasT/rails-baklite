# Rails::Baklite
Baklite adapter for Rails.

## Usage
Head to the documentation on [baklite.tortitas.eu/docs/rails](https://baklite.tortitas.eu/docs/rails) for a complete guide on how to use this gem.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "rails-baklite"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails-baklite
```

## Tests
For the tests to work you need an instance of Baklite running locally on port
3000. Then create a new user and head to http://localhost:3000/docs/rails, copy the code for credentials file.

Now execute the following commands:
```bash
cd test/dummy
bin/rails generate baklite
bin/rails credentials:edit -e test
```

Now run the tests from the root with:
```bash
bin/test
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
