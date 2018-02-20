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

Once installed, you will need to mount Feste in your application.

```ruby
# config/routes.rb
mount Feste::Engine => "/email-subscriptions", as: "feste"
```

## Configuration

Feste organizes subscribable emails by separating them into categories that you define (see <a href="#mailer">Mailer</a> for more details).  This requires an array of available category names to be provided to the `categories` configuration.

Out of the box, Feste allows your users to manage their subscriptions from a url in their email, which includes an identifying token.  If you would like for them to be able to do so from within your application, you will need to provide a method for identifying the currently logged in user.  Luckily, Feste provides authentication adapters for applications that use Devise and Clearance to manage user sessions.  Otherwise, you can provide a Proc to the `authenticate_with` option.

Optionally, you can set the attribute your user model(s) use(s) to reference a user's email address (`email_source`) and the host that is used by the `subscriptions_url` helper (`host`).  If you have multiple databse tables that store email addresses, and might have duplicates between them, you can provide the `model_hierarchy` option with an array of model classes, arranged from highest to lowest priorty (See <a href="#mailer">Model</a> for more details.)

```ruby
# initializers/feste.rb
authentication_method = Proc.new do |controller|
  ::User.find_by(id: controller.session[:user_id])
end

Feste.configure do |config|
  # set your category names
  config.categories = []
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
  # set a priorty hierarchy of models that might share email addresses
  config.model_hierarchy = nil
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

Please note that if you use multiple database tables to house user data, and different tables have duplicate email addresses between them, this may cause issues when Feste tries to find a record based on an email address.  This issue can be avoided by creating an array of model classes arranged in the order Feste should look for a record, with the highest priority model first (i.e. `[User, Lead, Inquirer]`).  Assign this array as the value of the `model_hierarchy` configuration option (see <a href="#configuration">Configuration</a> for more).

### Mailer

In your mailer, include the `Feste::Mailer` module.

Feste keeps track of email subscriptions by grouping mailer actions into categories that you define.  Your users will not be able to subscribe or unsubscribe to emails until you assign specific actions to a category.  In order to do this, you can call the `categorize` method within your mailer.  Doing so will automatically assign all actions in that mailer to the category you provide through the `as` option.

```ruby
class CouponMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: "Marketing Emails"

  def send_coupon(user)
    mail(to: user.email, from: "support@here.com")
  end
end
```

If you only want to categorize specific actions in a mailer, you can do so by listing those actions in an array as your first arguement.

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

#### Mailer View

In our view file, you can use the helper method `subscription_url` to link to the page where users can manage their subscriptions.

```html
<a href="<%= subscription_url %>">click here to unsubscribe</a> 
```

When a user clicks this link, they are taken to a page that allows them to choose which emails (by category) they would like to keep receiving, and which ones they would like to unsubscribe to. 

#### Application View

The route to the subscriptions page is the root of the feste engine.  You can link to this page from anywhere in your app using the `feste.subscriptions_url` helper (assuming the engine is mounted as 'feste').  When a logged in user visits this page from your application, they will be authenticated through the method which you provide in the configuration, and shown their email subscriptions.

### When not to use

It is recommended you DO NOT include any important emails, such as password reset emails, into a subscribable category.  It is also recommended you do not include the subscription link in any email that is sent to multiple recipients.  Though Feste comes with some security measures, it is assumed that each email is intended for only one recipient, and the `subscription_url` helper leads to a subsciption page meant only for that recipient.  Exposing this page to other users may allow them to change subscription preferences for someone else's account.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jereinhardt/feste.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

l create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).