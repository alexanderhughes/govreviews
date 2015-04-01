class PublicEntitiesController < ApplicationController
  def index
    @public_entities = PublicEntity.all
  end
  
  def show
    @post = Post.new
    @public_entity = PublicEntity.find(params[:id])
    @posts = PublicEntity.find(params[:id]).posts
  end

end
