class MainMailer < ActionMailer::Base
  include Feste::Mailer

  categorize [:send_mail, :send_more_mail], as: :marketing_emails

  def send_mail(user)
    mail(
      to: user.email,
      from: "support@email",
      subject: "subject",
      subscriber: user
    )
  end

  def send_more_mail(user)
    mail(
      to: user.email,
      from: "support@email",
      subject: "subject",
      subscriber: user
    )
  end

  def send_less_mail(user)
    mail(
      to: user.email,
      from: "support@email",
      subject: "subject",
      subscriber: user
    )
  end
end