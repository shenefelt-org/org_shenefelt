class Avo::Resources::Order < Avo::BaseResource
  self.icon = "tabler/outline/shopping-cart"
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
    field :user, as: :belongs_to
    field :stripe_checkout_session_id, as: :text
    field :stripe_payment_intent_id, as: :text
    field :status, as: :text
    field :total_amount, as: :number
  end
end
