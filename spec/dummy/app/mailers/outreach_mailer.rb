class OutreachMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: :outreach_emails

  def request_donation(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end
end
