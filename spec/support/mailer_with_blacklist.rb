class MailerWithBlacklist < ActionMailer::Base
  include Feste::Mailer

  allow_subscriptions except: [:blacklist_action]

  def whitelist_action(email)
    mail(to: email, from: "test@test.com", subject: "test")
  end

  def blacklist_action(email)
    mail(to: email, from: "test@test.com", subject: "test")
  end
end