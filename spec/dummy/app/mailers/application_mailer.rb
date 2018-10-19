class ApplicationMailer < ActionMailer::Base
  include Feste::Mailer

  default from: 'from@example.com'
  layout 'mailer'
end
