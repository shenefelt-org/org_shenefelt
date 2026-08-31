class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :orders, dependent: :nullify

  has_one  :employee_config, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

  # optional reverse of user_manager records
  has_many :user_managers, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true

  accepts_nested_attributes_for :employee_config, update_only: true
  accepts_nested_attributes_for :memberships, allow_destroy: true

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
    role = employee_config&.user_role.to_s
    ["super admin", "admin", "location admin", "light admin"].include?(role)
  end

  def full_name
    [first_name, last_name].map { |v| v.to_s.strip.presence }.compact.join(" ").presence
  end

  def display
    "Name: #{full_name}\n User Role: #{employee_config&.user_role}"
  end
end
