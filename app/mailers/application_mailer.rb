class ApplicationMailer < ActionMailer::Base
  default from: 'Woof app <confirmation@mywoofapp.com>'
  layout 'mailer'
end
