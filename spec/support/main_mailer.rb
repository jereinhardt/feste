class MainMailer < ActionMailer::Base
  include Feste::Mailer

  categorize [:send_mail, :send_more_mail], as: "Marketing Emails"

  def send_mail(user)
    mail(to: user.email, from: "support@email", subject: "subject")
  end

  def send_more_mail(user)
    mail(to: user.email, from: "support@email", subject: "subject")
  end

  def send_less_mail(user)
    mail(to: user.email, from: "support@email", subject: "subject")
  end
end