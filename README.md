# iCasework - Ruby client library

A Ruby interface to Civica's iCasework API platform for submitting and retrieving case information. This client library provides basic methods to interact with cases and case-related data from iCasework instances.

**Note:** This gem is not officially affiliated with or supported by Civica.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'icasework'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install icasework

## Usage

```ruby
# setup account
Icasework.account = ...
Icasework.api_key = ...

# create a case
Icasework::Case.create(type: 'InformationRequest',
                       request_method: 'Online Form',
                       customer: { name: name, email: email },
                       details: body)

# retrieve cases
Icasework::Case.where(type: 'InformationRequest',
                      from: start_date,
                      until: end_date)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mysociety/icasework-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/icasework/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Icasework project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/icasework/blob/master/CODE_OF_CONDUCT.md).
