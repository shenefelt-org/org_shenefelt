class Avo::Resources::Subscription < Avo::BaseResource
  self.icon = "tabler/outline/credit-card"
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
    field :product, as: :belongs_to
    field :active, as: :text
    field :billing_cycle_type, as: :text
  end
end
