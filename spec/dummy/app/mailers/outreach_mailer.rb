class OutreachMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: "Outreach Emails"

  def request_donation(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end
end
