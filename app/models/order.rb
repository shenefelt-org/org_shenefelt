class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  STATUSES = %w[pending paid failed canceled refunded].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :total_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def mark_paid!(payment_intent_id: nil)
    attrs = { status: "paid" }
    attrs[:stripe_payment_intent_id] = payment_intent_id if payment_intent_id.present?
    update!(attrs)
  end
end
