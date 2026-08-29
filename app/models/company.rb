class Company < ApplicationRecord
  has_many :locations,
           foreign_key: "companies_id",
           dependent: :destroy,
           inverse_of: :company

  validates :name, presence: true
end