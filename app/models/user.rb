# app/models/user.rb
class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    email = auth.info.email.to_s.strip.downcase
    raise "Authentik did not provide an email" if email.blank?

    user = find_by(provider: auth.provider, uid: auth.uid)
    user ||= find_by(email_address: email)

    if user
      user.update!(provider: auth.provider, uid: auth.uid, email_address: email)
    else
      user = create!(
        email_address: email,
        provider: auth.provider,
        uid: auth.uid,
        password: SecureRandom.hex(32)
      )
    end

    user
  end
end
