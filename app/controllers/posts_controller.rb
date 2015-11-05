class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  before_action :set_categories

  def index
    @posts = Post.all order: 'updated_at DESC'
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = User.first # TODO: Replace with current user when auth added

    if @post.save
      flash[:notice] = 'New post saved successfully.'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post updated successfully.'
      redirect_to @post
    else
      render :edit
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_categories
    @all_categories = Category.all order: 'name'
  end

  def post_params
    params.require(:post).permit!
  end
end
