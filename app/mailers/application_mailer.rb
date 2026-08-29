class ApplicationMailer < ActionMailer::Base
  default from: "greg@shenefelt.org"
  default to: "bb@buttonbox.cc"
  layout "mailer"
end
