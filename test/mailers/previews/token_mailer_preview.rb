# Preview all emails at http://localhost:3000/rails/mailers/token_mailer
class TokenMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/token_mailer/send_token
  def send_token
    TokenMailer.send_token
  end
end
