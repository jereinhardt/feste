class MarketingMailer < ApplicationMailer
  include Feste::Mailer

  categorize [:send_newssletter, :send_coupon_list], as: :marketing_emails

  def send_newsletter(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end

  def send_coupon_list(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end

  def send_offer(user)
    mail(to: user.email, from: "support@app.com", subscriber: user)
  end
end
