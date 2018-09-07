# ActsAsAlertable
This engine will help you to have a flexible alert module for you rails application

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_alertable', git: 'git://github.com/webdox/acts_as_alertable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install acts_as_alertable

After that you need to install the engine migrations and migrate your database

	$ rails generate acts_as_alertable:install && rake db:migrate

## Usage

With this engine you have 2 modules to be included to your application models:

### 1. ActsAsAlertable::Alertable
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

### 2. ActsAsAlertable::Alerted
This module allow you to indicate which application model will be alerted, we recommend to use model with a `name` and `email` property:

```ruby
class User < ActiveRecord::Base
	...
	include ActsAsAlertable::Alerted
	...
end
```

With this, now we can include users to an alert for be alerted:

```ruby
article = Article.create!
user = User.create! name: 'MyUser', email: 'myuser@alerted.com'
alert = article.alerts.create name: "Alert for my article"
alert.users << user
```

## Components
An alert has a couple important components to describe:

### 1. Alertable Objects
The alert has a relation of `many to many` with the alertable model, so, the alert will be applied to many objects.
```ruby
article1 = Article.create!
article2 = Article.create!

alert = article1.alerts.create! name: "Important Notification"
article2.alerts << alert

alert.alertables # => [#<Article id: 1 >, #<Article id: 2 >]
alert.articles # => [#<Article id: 1 >, #<Article id: 2 >]
```

### 2. Alerted Objects
The alert has a relation of `many to many` with the alerted model, so, the notifications of the alert will be sended to many objects.
```ruby
alert.users << User.create!(name: 'MyUser#1', email: 'myuser1@alerted.com')
alert.users << User.create!(name: 'MyUser#1', email: 'myuser1@alerted.com')
```

### 3. Kind
The kind of an alert specify the behavior of it. There are 3 kinds:

#### `date_trigger`
Basic behavior using a specific date an a list of notifications for trigger the alert.
This list of notifications is a serialize attribute of the aler, like:

```ruby
alert.notifications = [
	{
		type: :month,
		value: -1
	},
	{
		type: :days,
		value: 5
	}
]
alert.save!
```

In this case, using an specific date, the alert will send notification 1 month before, and 5 days after the date.

#### `simple_periodic`
Behavior based on cron format, this kind of alert will take a cron format string to trigger the alert notification.

```ruby
alert.cron_format = '0 0 * * *'
alert.save!
```

In this case, the alert will be send notifications every single day

#### `advanced_periodic`
Behavior based on cron format + specific date, this kind of alert will take a cron format string to trigger the alert notification using a apecific date as reference


### 3. Observable Date

The `observable_date`is the attribute of the alertable object that will be use like a reference to trigger notifications for alerts of kind `date_trigger` and `advanced_periodic`. By default this value is set to the `created_at` property of the alertable object.
```
article.created_at # => Fri, 07 Sep 2018 18:23:55 UTC +00:00
alert.observable_dates # => [Fri, 07 Sep 2018]
```

_note: The alert could be alerting many alertable objects, that's why the `observable_dates` returns an array of dates._

## Trigger Notification and more

In order to trigger the notifications you need to call the method `check!`, like:

```ruby
ActsAsAlertable::Alert.check!
```

This method will evaluate if the day when you call the method you have notification to be sended and will send it. You can evaluate a different date with:

```ruby
ActsAsAlertable::Alert.check_for(Date.new(2018,9,9))
```

This method will evaluate if you have notification to be sended at `2018-09-09` and will send it.

Alert have more helper methods like:

```ruby
alert.trigger_dates #=> list of date to trigger a notification
```

```ruby
alert.sendeable_date?(date) #=> boolean, indicate if the date is a trigger date
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/webdox/acts_as_alertable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).