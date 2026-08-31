class Product < ApplicationRecord
  has_many :order_items, dependent: :restrict_with_exception
  has_many :orders, through: :order_items

  validates :title, presence: true
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }

  def price_dollars
    price_in_cents.to_f / 100.0
  end

  def sync_to_stripe!
    stripe_product = Stripe::Product.create({
      name: title,
      description: description
    })

    stripe_price = Stripe::Price.create({
      product: stripe_product.id,
      unit_amount: price_in_cents,
      currency: "usd"
    })

    update!(
      stripe_product_id: stripe_product.id,
      stripe_price_id: stripe_price.id
    )
  end
end