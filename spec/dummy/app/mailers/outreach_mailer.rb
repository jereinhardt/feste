class OutreachMailer < ApplicationMailer
  include FesteMailer

  categorize as: "Outreach Emails"

  def request_donation(user)
    mail(to: user.email, from: "support@app.com")
  end
end
