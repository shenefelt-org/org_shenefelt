# app/models/customer.rb
class Customer < ApplicationRecord
  has_many :quotes, dependent: :nullify

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end