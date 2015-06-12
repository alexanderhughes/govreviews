class PublicEntitiesController < ApplicationController
  def index
    @public_entities = PublicEntity.all
    @categories = Category.all
    @posts = Post.all
    @nyc_executives = PublicEntity.where(entity_type: 'city executive')
    @nyc_agencies = PublicEntity.where(authority_level: 'city', entity_type: 'agency')
    @nyc_subway_stations = PublicEntity.where(entity_type: 'subway_station')
    @nyc_post_offices = PublicEntity.where(entity_type: 'post_office')
    @nystate_agencies = PublicEntity.where(authority_level: 'state', entity_type: 'agency')
    @nystate_parks = PublicEntity.where(authrority_level: 'state', entity_type: 'park')
    @ten_most_recent_posts = Post.order_by(:created_at => 'desc').limit(10)
  end
  
  def show
    @post = Post.new
    @public_entity = PublicEntity.find(params[:id])
    @posts = PublicEntity.find(params[:id]).posts
    @categories = PublicEntity.find(params[:id]).categories
  end

end
