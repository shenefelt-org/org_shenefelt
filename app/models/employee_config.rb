class EmployeeConfig < ApplicationRecord
  belongs_to :user
  belongs_to :location, optional: true
  has_one :company, through: :location

  validates :user_id, uniqueness: true
end