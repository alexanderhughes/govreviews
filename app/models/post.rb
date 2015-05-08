class Post < ActiveRecord::Base
  belongs_to :public_entity
  belongs_to :user
end
