class MailerWithBlacklist < ActionMailer::Base
  include Feste::Mailer

  allow_subscriptions except: [:blacklist_action]

  def whitelist_action(user)
    subscriber(user)
    mail(to: user.email_address, from: "test@test.com", subject: "test")
  end

  def blacklist_action(user)
    subscriber(user)
    mail(to: user.email_address, from: "test@test.com", subject: "test")
  end
end