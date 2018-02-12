class ReminderMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: "Reminder Emails"

  def send_reminder(user)
    mail(to: user.email, from: "support@app.com")
  end

  def send_email_confimation_reminder(user)
    mail(to: user.email, from: "support@app.com")
  end
end
