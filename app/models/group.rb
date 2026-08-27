class Group < ApplicationRecord
    has_many :memberships, dependent: :destroy
    has_many :users, through: :memberships
    
    def is_admin_group?
        # Check if the group is an admin group
        self.name == "admin" || self.name == "root" || self.name == "superuser"
    end

    def create
        # Custom create logic here
    end
end
