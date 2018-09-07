# ActsAsAlertable
This engine will help you to have a flexible alert module for you rails application

## Installation

Add this line to your application's Gemfile:

```
gem 'acts_as_alertable', git: git://github.com/webdox/acts_as_alertable
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install acts_as_alertable

After that you need to install the engine migrations and migrate your database

	$ rails generate acts_as_alertable:install && rake db:migrate

## Usage

With this engine you have 2 modules to be included to your application models:

#### ActsAsAlertable::Alertable
This module allow you to indicate which application model will be under alert. Like:
```
class Article < ActiveRecord::Base
	...
	include ActsAsAlertable::Alertable
	...
end

```
In this case, the Article model now can have alerts:

```
article = Article.create!
alert = article.alerts.create name: "Alert for my article"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/citybox_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).