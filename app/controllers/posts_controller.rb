class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.create(post_params)
    @post.public_entity_id = BSON::ObjectId.from_string(@post.public_entity_id)
    @post.user_id = current_user.id
    @post.save
    redirect_to public_entity_path(@post.public_entity)
  end
  
  def show
    @post = Post.find(params[:id])
  end    
  
  private
  def post_params
    params[:post].permit(:title, :rating, :review, :public_entity_id, :user)
  end
end
