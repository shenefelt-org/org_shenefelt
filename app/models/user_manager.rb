class UserManager < ApplicationRecord
  belongs_to :user
  belongs_to :membership
  belongs_to :employee_config
end
