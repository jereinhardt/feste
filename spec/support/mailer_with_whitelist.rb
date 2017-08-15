class MailerWithWhitelist < ActionMailer::Base
  include Feste::Mailer

  allow_subscriptions only: [:whitelist_action]

  def whitelist_action(email)
    mail(to: email, from: "test@test.com", subject: "test")
  end

  def other_action(email)
    mail(to: email, from: "test@test.com", subject: "test")
  end
end