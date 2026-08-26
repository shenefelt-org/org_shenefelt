class InjuryReport < ApplicationRecord
  SEVERITIES = %w[minor moderate serious critical].freeze

  validates :name, :email, :injured_person, :incident_date, :location, :description, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :severity, inclusion: { in: SEVERITIES }, allow_blank: true
  validates :description, length: { minimum: 20 }
end