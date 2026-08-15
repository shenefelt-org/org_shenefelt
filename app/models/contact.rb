class Contact < ApplicationRecord
    has_one :client_contact, dependent: :destroy
end
