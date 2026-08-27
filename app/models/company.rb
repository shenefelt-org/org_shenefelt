class Company < ApplicationRecord
  has_many :locations, dependent: :destroy
end
