# app/models/user.rb
class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_one :employee_config, dependent: :destroy
  #establish employee group memberships
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

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

  def admin?
    admin_roles = [ "super admin", "admin", "location admin", "light admin" ]
    admin_roles.include?(self.employee_config.user_role)
  end

  def full_name
    "#{first_name} #{last_Name}"
  end

  def display
    "Name: #{first_name} #{last_name}\n User Role: #{self&.employee_config.&user_role}"
  end
end
