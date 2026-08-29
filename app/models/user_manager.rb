class UserManager < ApplicationRecord
  belongs_to :user
  belongs_to :created_by, class_name: "User", optional: true
  self.table_name = "user_managers"
end