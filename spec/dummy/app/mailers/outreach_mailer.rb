class OutreachMailer < ApplicationMailer
  def request_donation(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end
end
