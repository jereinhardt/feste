class MainMailer < ActionMailer::Base
  include Feste::Mailer

  def send_mail(email)
    mail(to: email, from: "support@email", subject: "subject")
  end
end