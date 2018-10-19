class ReminderMailer < ApplicationMailer
  def send_reminder(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end

  def send_email_confimation_reminder(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end
end
