class MarketingMailer < ApplicationMailer
  include Feste::Mailer

  categorize as: "Marketing Emails"

  def send_newsletter(user)
    mail(to: user.email, from: "support@app.com")
  end

  def send_coupon_list(user)
    mail(to: user.email, from: "support@app.com")
  end

  def send_offer(user)
    mail(to: user.email, from: "support@app.com")
  end
end
