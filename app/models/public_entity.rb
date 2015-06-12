class PublicEntity
  #postgresql
  #has_many :posts
  #has_and_belongs_to_many :categories
  #has_many :subordinates, class_name: "PublicEntity", :foreign_key => "superior_id"
  #belongs_to :superior, class_name: "PublicEntity"
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  field :name
  field :authority_level
  field :address
  field :description
  field :website
  field :entity_type
  field :superior_id
  field :chief_id
  field :phone
  field :coordinates, :type => Array
  has_and_belongs_to_many :categories
  has_many :posts
  has_many :subordinates, class_name: "PublicEntity", :foreign_key => "superior_id"
  belongs_to :superior, class_name: "PublicEntity"
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end