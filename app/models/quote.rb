class Quote < ApplicationRecord
    has_many :line_items, dependent: :destroy
    has_many :products, through: :line_items
    belongs_to :customer, optional: true

    def calculate_total
        # sum each related costQuote.
        sum = line_items.sum("quantity * unit_price")

        # update this model if needed
        update(total_amount: line_items.sum("quantity * unit_price")) unless total_amount == sum

        total_amount
    end
end
