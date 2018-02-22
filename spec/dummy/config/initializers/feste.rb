authentication_method = Proc.new do |controller|
  ::User.find_by(id: controller.session[:user_id])
end

Feste.configure do |config|
  config.categories = [
    :marketing_emails,
    :reminder_emails,
    :outreach_emails
  ]
  config.authenticate_with = authentication_method
end