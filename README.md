# AttributesMapper

Builds upon `[json-path-builder](https://github.com/omnitech-solutions/json-path-builder)` to deliver a highly declarative and dynamic mapping of JSON/Hash Attributes

## Console
run `irb -r ./dev/setup` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attributes-mapper'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install attributes-mapper

## Usage

```ruby
class UserAttributesMapper < AttributesMapper::Builder
  configure do |config|
    config.required_attributes = %i[name email]
    config.optional_attributes = %i[age key]
    config.scopes = { profile: 'user.profile', info: 'user.info' }
  end

  name { { from: :username, scope: :profile } } # corresponds to path `user.profile.username`
  email { { from: :email, scope: :profile } } # corresponds to path `user.profile.email`
  age { { from: :age, scope: :info } } # corresponds to path `user.info.age`
  key { { from: :key } } # corresponds to path `key`
end

input = { user:
            { profile:
                {
                  username: 'Joe Bloggs',
                  email: 'joe@email.com'
                },
              info: {

                age: 23
              }
            },
          key: 'some-value'
}

builder = UserAttributesMapper.new(input).build
builder.to_h #=> { name: 'Joe Bloggs', email: 'joe@email.com', age: 23, key: 'some-value' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/attributes-mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/attributes-mapper/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Attributes::Mapper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/attributes-mapper/blob/master/CODE_OF_CONDUCT.md).
