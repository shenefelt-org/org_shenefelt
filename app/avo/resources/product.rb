class Avo::Resources::Product < Avo::BaseResource
  self.icon = "tabler/outline/package"
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
    field :title, as: :text
    field :description, as: :textarea
    field :price_in_cents, as: :number
    field :stripe_product_id, as: :text
    field :stripe_price_id, as: :text
    field :active, as: :boolean
  end
end
