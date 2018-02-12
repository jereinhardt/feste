class MainMailer < ActionMailer::Base
  include Feste::Mailer

  categorize as: "Marketing Emails"

  def send_mail(user)
    mail(to: user.email, from: "support@email", subject: "subject")
  end

  def send_more_mail(user)
    mail(to: user.email, from: "support@email", subject: "subject")
  end
end