class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "party@example.com")
  layout false
end
