class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.create(post_params)
    redirect_to public_entity_path(@post.public_entity)
  end
  
  def show
    @post = Post.find(params[:id])
  end    
  
  private
  def post_params
    params[:post].permit(:title, :rating, :review, :public_entity_id)
  end
end
