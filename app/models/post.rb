class Post
  #postgresql
  #belongs_to :public_entity
  #belongs_to :user
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :public_entity
  belongs_to :user
  field :title
  field :rating
  field :review
  field :public_entity_id
  field :user_id
end
