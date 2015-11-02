class PostsController < ApplicationController
  def index
    @posts = Post.all order: 'updated_at DESC'
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
