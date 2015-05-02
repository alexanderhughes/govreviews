class PublicEntity < ActiveRecord::Base
  has_many :posts
  has_and_belongs_to_many :categories
  has_many :subordinates, class_name: "PublicEntity", :foreign_key => "superior_id"
  belongs_to :superior, class_name: "PublicEntity"
end
