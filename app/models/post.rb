class Post
  #postgresql
  #belongs_to :public_entity
  #belongs_to :user
  include Mongoid::Document
  include Mongoid::Timestamps
  include AlgoliaSearch
  algoliasearch do
    attribute :review
  end
  belongs_to :public_entity
  belongs_to :user
  field :rating
  field :review
  field :public_entity_id
  field :user_id
  field :use_it_again
  field :recommend_to_friend
  field :satisfaction
  field :value_for_money
end
