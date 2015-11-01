class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  
  def show
    @category = Category.find(params[:id])
    @public_entities = PublicEntity.all
  end
  
end
