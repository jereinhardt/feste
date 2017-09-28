Feste is an easy way to give your users the ability to subscribe and unsubscribe to emails that come from your application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'feste'
```

And then execute:

    $ bundle

Once installed, you will need to mount Feste in your application

```ruby
# config/routes.rb
mount Feste::Engine => "/feste"
```

## Usage

### Model

In the model that holds your users' data, include `Feste::User`.

```ruby
class User < ApplicationRecord
  include Feste::User
end
```

Feste identifies your users by email address.  Feste assumes that your user model has an `email` attribute to reference a user's email address.  If you access your user's email through a different attribute or method, you can tell Feste the correct alias using `subscriber_email_source`.

```ruby
class User < ApplicationRecord
  include Feste::User

  email_source :find_email_address

  def find_email_address
    # method that returns the user's email address
  end
end
```

### Mailer

In your mailer, include the `Feste::Mailer` module.  In your mailer actions, you need to register an instance of the model that includes Feste's user module.  You can do this using the `subscriber` method.

```ruby
class PasswordMailer < ApplicationMailer
  include Feste::Mailer

  def send_password_reset_email(user)
    subscriber(user)
    mail(to: user.email, from: "support@here.com")
  end
end
```

When you include the `Feste::Mailer` module in a mailer, by default, Feste will attempt to process every outgoing action belonging to that mailer.  You can specify which actions you want Feste to process using the `allow_subscriptions` method.  This method takes one of two options: `only` which will stop Feste from processing any actions other than those given, and `except`, which will stop Feste from processing the actions given.

```ruby
class NewMessageMailer < ApplicationMailer
  include Feste::Mailer

  allow_subscriptions only: [:new_message]

  def new_message(message)
    subscriber(message.recipient)
    mail(to: message.recipient.email, from: message.author.email)
  end

  def new_notification(notification)
    mail(to: notification.recipient.email, from: "us@support.com")
  end
end
```
```ruby
class NewMessageMailer < ApplicationMailer
  include Feste::Mailer

  allow_subscriptions except: [:new_notification]

  def new_message(message)
    subscriber(message.recipient)
    mail(to: message.recipient.email, from: message.author.email)
  end

  def new_notification(notification)
    mail(to: notification.recipient.email, from: "us@support.com")
  end
end
```

### View

In order to create a link that allows users to manage their subscription, you can generate a url using the `subscription_url` method in your mailer, and assigning the value to an instance variable

```ruby
@subscription_url = subscription_url
```

When a user clicks this link, they are taken to a page that allows them to unsubscribe to that specific email, or all emails coming from your application.  If they are already unsubscribed, they are given the option to resubscribe.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jereinhardt/feste.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

