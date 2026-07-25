class TokenMailer < ApplicationMailer
  default from: 'noreply@shenefelt.org'

  def send_token(email, token)
    @token = token
    mail(to: email, subject: 'Your Bearer Token - shenefelt.org')
  end
end
