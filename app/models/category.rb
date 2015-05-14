class Category < ActiveRecord::Base
  #postgresql
  #has_and_belongs_to_many :public_entities
  include Mongoid::Document
  include Mongoid::Timestamps
  has_and_belongs_to_many :public_entities
  field :name
  field :category_id
  field :public_entity_id
end
