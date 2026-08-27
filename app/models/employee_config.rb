class EmployeeConfig < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_one :company, through: :location

end
