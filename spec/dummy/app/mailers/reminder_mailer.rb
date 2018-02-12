class ReminderMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: "Marketing Emails"

  def send_reminder(user)
    mail(to: user.email, from: "support@app.com")
  end
end
