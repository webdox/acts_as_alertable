# ActsAsAlertable
This engine will help you to have a flexible alert module for you rails application

## Installation

Add this line to your application's Gemfile:

```ruby
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

#### 1. ActsAsAlertable::Alertable
This module allow you to indicate which application model will be under alert, like:
```ruby
class Article < ActiveRecord::Base
	...
	include ActsAsAlertable::Alertable
	...
end

```
In this case, the Article model now can have alerts:

```ruby
article = Article.create!
alert = article.alerts.create name: "Alert for my article"
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/webdox/acts_as_alertable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).