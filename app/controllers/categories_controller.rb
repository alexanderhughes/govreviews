class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end  

  def new
    @categories = Category.new
  end
  
  def create
  end
  
  def show
    @categories = Category.find(params[:id])
    @public_entities = PublicEntity.all
  end    
  
end
