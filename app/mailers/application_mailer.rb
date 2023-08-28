class ApplicationMailer < ActionMailer::Base
  default(
    from: email_address_with_name(Rails.application.credentials.dig(:gmail, :email), 'TaskWith')
  )
  layout "mailer"
end
