module Jumpstart
  class ApplicationMailer < ActionMailer::Base
    default from: Jumpstart.config.support_email
    layout "mailer"
  end
end
