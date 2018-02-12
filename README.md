Feste is an easy way to give your users the ability to subscribe and unsubscribe to emails that come from your application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'feste'
```

And then execute:

    $ bundle install
    $ rails generate feste:install
    $ rake db:migrate

Once installed, you will need to mount Feste in your application

```ruby
# config/routes.rb
mount Feste::Engine => "/email-subscriptions"
```

## Configuration

There are a two major configurate options Feste makes available.  The first is `email_source`.  This is the attribute on your user model that references the user's email address.  It is set to `email` by default, but can be changed to an alias attribute or method.  The second configuration option is `host`, which is set to your `ActionMailer::Base.default_url_options[:host]` value by default.

```ruby
# initializers/feste.rb
Feste.configure do |config|
  config.email_source = :email
  config.host = ENV["FESTE_HOST"]
end
```

## Usage

### Model

In the model that holds your users' data, include `Feste::User`.

```ruby
class User < ApplicationRecord
  include Feste::User
end
```

This will give your user model a `has_many` relationship to `subscriptions`.  Since this relationship is polymorphic, your can include the `Feste::User` module in multiple models.

### Mailer

In your mailer, include the `Feste::Mailer` module.

Feste keeps track of email subscriptions by grouping mailer actions into categories that you define.  Your users will no be able to subscribe or unsubscibe to emails until you assign specific actions to a category.  In order to do this, you can call the `categorize` method within your mailer.  Doing so will automatically assign all actions in that mailer to the category you provide through the `as` option.

```ruby
class CouponMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: "Marketing Emails"

  def send_coupon(user)
    mail(to: user.email, from: "support@here.com")
  end
end
```

If you only want to categorize specific actions in a mailer to a category, you can do so by listing those actions in an array as your first arguement.

```ruby
class CouponMailer < ApplicationMailer
  include Feste::Mailer

  categorize [:send_coupon], as: "Marketing Emails"
  categorize [:send_coupon_reminder], as: "Reminder Emails"

  def send_coupon(user)
    mail(to: user.email, from: "support@here.com")
  end

  def send_coupon_reminder(user)
    mail(to: user.email, from: "support@here.com")
  end
end
```

### View

In our view file, you can use the helper method `subscription_url` to link to the page where users can manage their subscriptions.

```html
<a href="<%= subscription_url %>">click here to unsubscribe</a> 
```

When a user clicks this link, they are taken to a page that allows them to unsubscribe from the email they received, or all emails coming from your application.  If they unsubscribe from all emails, the only emails that will be stopped will be those coming from mailers that have Feste's Mailer module included.  That way, you don't have to worry about users unsubscribing from essential emails coming from your application.  

### When not to use

It is recommended you DO NOT include the `Feste::Mailer` module in any mailer that handles improtant emails, such as password reset emails.  If you do, make sure to blacklist any important mailer actions.

It is also recommended you do not include the subscription link in any email that is sent to multiple recipients.  Though Feste comes with some security measures, the `subscription_url` helper leads to a subsciption page meant only for the user targeted by the `subscriber` method in the mailer.  Exposing this page to other recipients may allow them to change another users subscription preferences.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jereinhardt/feste.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

