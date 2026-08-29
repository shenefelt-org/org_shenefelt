# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
puts "Cleaning database..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all

puts "Creating dummy products in Stripe and Rails..."

# Define some dummy portfolio items
dummy_items = [
  { title: "Minimalist Portfolio Theme", description: "A clean, dark-mode portfolio.", price_in_cents: 2900 },
  { title: "E-Commerce UI Kit", description: "Figma files for a complete store.", price_in_cents: 4900 },
  { title: "1-on-1 Consulting Hour", description: "Code review and architecture advice.", price_in_cents: 15000 }
]

dummy_items.each do |item|
  # 1. Create the product in Stripe
  stripe_product = Stripe::Product.create({
    name: item[:title],
    description: item[:description]
  })

  # 2. Create the price in Stripe and attach it to the product
  stripe_price = Stripe::Price.create({
    product: stripe_product.id,
    unit_amount: item[:price_in_cents],
    currency: 'usd'
  })

  # 3. Save everything to the local Rails database
  Product.create!(
    title: item[:title],
    description: item[:description],
    price_in_cents: item[:price_in_cents],
    stripe_product_id: stripe_product.id,
    stripe_price_id: stripe_price.id,
    active: true
  )

  puts "Created: #{item[:title]}"
end

puts "✅ Seeded #{Product.count} products successfully!"
