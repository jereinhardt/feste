class ReminderMailer < ApplicationMailer
  include Feste::Mailer

  def send_reminder(user)
    subscriber(user)
    mail(to: user.email, from: "support@app.com")
  end
end
