:email: Feste is an easy way to give your users the ability to manage email subscriptions in your Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'feste'
```

And then execute:

    $ bundle install
    $ rails generate feste:install
    $ rake db:migrate

### Mounting the Engine

Feste comes with two mountable engines.  `Feste::Engine` provides the interface your users see when they manage their subscriptions.  `Feste::Admin::Engine` provides an interface you will use to sort subscribable emails into different categories.  You will need to mount both engines in your `config/routes.rb` file.

```ruby
# config/routes.rb

mount Feste::Engine => "/email-subscriptions", as: "feste"

namespace :admin do
  mount Feste::Admin::Engine => "feste", as: "feste"
end
```

## Configuration

Out of the box, Feste allows your users to manage their subscriptions from a url in their email, which includes an identifying token.  If you would like for them to be able to do so from within your application, you will need to provide a method for identifying the currently logged in user.  Luckily, Feste provides authentication adapters for applications that use Devise and Clearance to manage user sessions.  Otherwise, you can provide a Proc to the `authenticate_with` option.

Optionally, you can set the attribute your user model(s) use(s) to reference a user's email address (`email_source`) and the host that is used by the `subscriptions_url` helper (`host`).

```ruby
# initializers/feste.rb
authentication_method = Proc.new do |controller|
  ::User.find_by(id: controller.session[:user_id])
end

Feste.configure do |config|
  # for applications that use clearance
  config.authenticate_with = :clearance
  # for applications that use devise
  config.authenticate_with = :devise
  # for applications that use custom authentication
  config.authenticate_with = authentication_method
  # set the email attribute of your user model
  config.email_source = :email
  # set the host for subscription_url
  config.host = ActionMailer::Base.default_url_options[:host]
  # set callbacks
  config.callback_handler = FesteCallbackHandler.new
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

In your `ApplicationMailer`, include the `Feste::Mailer` module.

```ruby
class ApplicationMailer < ActionMailer::Base
  include Feste::Mailer
end
```

When calling the `mail` method, make sure to explicitly state which user the subscription should be applied to using the `subscriber` option.

```ruby
class CouponMailer < ApplicationMailer
  def send_coupon(user)
    mail(to: user.email, from: "support@here.com", subscriber: user)
  end
end
```

### View

#### Mailer View

In our view file, you can use the helper method `subscription_url` to link to the page where users can manage their subscriptions.

```html
<a href="<%= subscription_url %>">click here to unsubscribe</a> 
```

When a user clicks this link, they are taken to a page that allows them to choose which emails (by category) they would like to keep receiving, and which ones they would like to unsubscribe to. 

#### Application View

The route to the subscriptions page is the root of the feste engine.  You can link to this page from anywhere in your app using the `feste.subscriptions_url` helper (assuming the engine is mounted as 'feste').  When a logged in user visits this page from your application, they will be authenticated through the method which you provide in the configuration, and shown their email subscriptions.


## Callbacks

If you would like to create callbacks for when a user unsubscribes or resubscribes to a mailing list, you can do so by creating a callback handler.  Callback handlers should be objects with two instance methods: `unsubscribe` and `resubscribe`.  You can register an instance of this object as your callback handler with the `callback_handler` configuration option.

```ruby
# config/initializers/feste.rb

class CallbackHandler
  def unsubscribe(event)
    # This method is called whenever a user unsubscribes from an mailing list they were previously subscribed to.
    event[:controller] # the instance of the controller
    event[:subscriber] # the user that unsubscribed
  end

  def resubscribe(event)
    # This method is called whenever a user subscribes to a mailing list they were previously unsubscribed to.
  end
end

Feste.configure do |config|
  config.callback_handler = CallbackHandler.new
end
```

## When not to use

It is recommended you DO NOT include any important emails, such as password reset emails, into a subscribable category.  It is also recommended you do not include the subscription link in any email that is sent to multiple recipients.  Though Feste comes with some security measures, it is assumed that each email is intended for only one recipient, and the `subscription_url` helper leads to a subsciption page meant only for that recipient.  Exposing this page to other users may allow them to change subscription preferences for someone else's account.

## Upgrading from 0.3 to 0.4

Feste 0.4.0 uses a new paradigm for sorting emails.  Before, categories were saved as a configuration, and assigned in each mailer.  With the update in 0.4, categories are instead saved in the database, and managed in your application.  If you are updating Feste from version 0.3 to 0.4, you'll need to take a few extra steps to comply with this new paradigm.

### Setup

First run the following commands

```
rails g feste:upgrade
rake db:migrate
```

Running `rails g feste:upgrade` will generate a migration that creates a `feste_categories` table.  This migration will check all of your existing subscriptions and create create categories for them, and sort the propper emails into each category.

Once you have done this, you can delete the `categories` configuration from your `initializers/feste.rb` file.

Then, go to your `routes.rb` file and mount `Feste::Admin::Engine` at your preferred path.  You can then visit that route and see the categories Feste has created, and manage them accordingly.

### Cutting Code

Instead of including `Feste::Mailer` in each mailer that is subscribable, you will instead include it in `ApplicationMailer`.  While you are removing the included module from your individual mailers, you can also remove calls the the `categorize` method, since you won't be using it to sort emails anymore.

If you had an I18n keys to make category names more readeable, you can go ahead and delete those as well.

### A NOTE ON DATABSE MIGRATIONS AND UPDATING FROM 0.3 to > 0.4

The update to 0.4 introduces the deprecation of certain methods and attributes on mailer classes that are no longer needed for managing email categories.  However, the database migration created by `rails g feste:upgrade` requires these deprecated methods remain in place durring the migration.  The purpose of this migration is to update your database while still preserving your users' data.  The methods being deprecated will not serve a purpose going forward, but in the update, they help parse the categories you are currently using in production and build accurate relations to corresponding subscriptions and users.  These methods can be removed once the migrations have been run.

It should be noted that these deprectaed methods will be removed completely in 1.0.  Once that happens, if you are planning on upgrading from 0.3 to 1.0 or higher, you will first need to update to 0.4, run the migrations, then update to your desired version number.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jereinhardt/feste.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

l create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
