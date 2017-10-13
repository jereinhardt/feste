class MainMailer < ActionMailer::Base
  include Feste::Mailer

  def send_mail(user)
    subscriber(user)
    mail(to: user.email, from: "support@email", subject: "subject")
  end
end