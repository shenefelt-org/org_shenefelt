class Location < ApplicationRecord
  # add_reference :locations, :companies created companies_id
  belongs_to :company, foreign_key: "companies_id", optional: true

  has_many :employee_configs, dependent: :nullify

  validates :name, presence: true

  def display_name
    company_name = company&.name
    company_name.present? ? "#{name} (#{company_name})" : name.to_s
  end

  def self.for_company(company_id)
    return none if company_id.blank?

    where(companies_id: company_id).order(:name)
  end
end