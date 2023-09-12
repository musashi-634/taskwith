class UserMailer < Devise::Mailer
  # See https://github.com/heartcombo/devise/wiki/How-To:-Use-custom-mailer
  #
  helper :application # gives access to all helpers defined within `application_helper`.
  # include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'users/mailer' # to make sure that your mailer uses the devise views
  # If there is an object in your application that returns a contact email,
  # you can use it as follows
  # Note that Devise passes a Devise::Mailer object to your proc, hence the parameter throwaway (*).
  default from: ->(*) do
    email_address_with_name(Rails.application.credentials.dig(:gmail, :email), 'TaskWith')
  end

  def invitation_instructions(record, token, opts = {})
    opts[:subject] = t(
      "users.mailer.invitation_instructions.subject",
      user_name: record.invited_by.name,
      organization_name: record.invited_by.organization.name
    )
    super
  end
end
