class Group < ApplicationRecord
    has_many :users

    def is_admin_group?
        # Check if the group is an admin group
        self.name == "admin" || self.name == "root" || self.name == "superuser"
    end

    def create
        # Custom create logic here
    end
end
