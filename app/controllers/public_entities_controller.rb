class PublicEntitiesController < ApplicationController
  def index
    @public_entities = PublicEntity.all
    @categories = Category.all
    @posts = Post.all
    #@city_executives = PublicEntity.where
  end
  
  def show
    @post = Post.new
    @public_entity = PublicEntity.find(params[:id])
    @posts = PublicEntity.find(params[:id]).posts
    @category = Category.find(params[:id])
  end

end
