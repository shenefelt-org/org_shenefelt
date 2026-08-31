class AddApprovalStatusToQuote < ActiveRecord::Migration[8.1]
  def change
    add_column :quotes, :approved, :boolean
  end
end
