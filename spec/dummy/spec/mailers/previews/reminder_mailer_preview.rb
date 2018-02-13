# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def send_reminder
    ReminderMailer.send_reminder(user)
  end

  private

  def user
    User.first || User.create(
      first_name: "Joe",
      last_name: "Someone",
      email: "joe@shmo.com"
    )
  end
end
