class Avo::Resources::Customer < Avo::BaseResource
  self.icon = "tabler/outline/user"
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
    field :name, as: :text
    field :email, as: :text
    field :phone, as: :text
    field :company_name, as: :text
    field :notes, as: :textarea
  end
end
