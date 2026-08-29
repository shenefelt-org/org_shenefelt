class Avo::Resources::OrderItem < Avo::BaseResource
  # self.icon = "tabler/outline/users"
  # self.avatar = {
  #   source: :avatar
  # }
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    # field :avatar, as: :avatar
    field :order, as: :belongs_to
    field :product, as: :belongs_to
    field :quantity, as: :number
    field :price_at_purchase, as: :number
  end
end
