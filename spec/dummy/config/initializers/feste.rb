authentication_method = Proc.new do |controller|
  ::User.find_by(id: controller.session[:user_id])
end

Feste.configure do |config|
  config.categories = [
    "Marketing Emails",
    "Reminder Emails",
    "Outreach Emails"
  ]
  config.authenticate_with = authentication_method
end