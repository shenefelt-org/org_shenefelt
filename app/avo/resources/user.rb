class Avo::Resources::User < Avo::BaseResource
  self.icon = "tabler/outline/users"
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
    field :email_address, as: :text
    field :email, as: :text
    field :provider, as: :text
    field :uid, as: :text
    field :user_role, as: :textarea
    field :sessions, as: :has_many
  end
end
