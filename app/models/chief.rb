class Chief
  #postgresql
  #has_many :posts
  #has_and_belongs_to_many :categories
  #has_many :subordinates, class_name: "PublicEntity", :foreign_key => "superior_id"
  #belongs_to :superior, class_name: "PublicEntity"
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :title
  field :salary
  field :election_info
  field :public_entity_id
  field :source
  field :source_accessed
  belongs_to :public_entity
end
