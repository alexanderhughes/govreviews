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
    @nystate_parks = PublicEntity.where(entity_type: 'park')
    @ten_most_recent_posts = Post.order_by(:created_at => 'desc').limit(10)
  end
  
  def user_location
    if current_user != nil
      render json: current_user.to_coordinates
    end
  end
  
  def entity_location
    if PublicEntity.find_by(params[:id]) != nil
      render json: PublicEntity.find_by(params[:id]).to_coordinates
    end
  end
  
  def show
    @post = Post.new
    @public_entity = PublicEntity.find(params[:id])
    @posts = PublicEntity.find(params[:id]).posts.order_by(:created_at => 'desc')
    @categories = PublicEntity.find(params[:id]).categories
    @subordinates = PublicEntity.find(params[:id]).subordinates
    @public_entity_coordinates = PublicEntity.find(params[:id]).to_coordinates
  end

end
