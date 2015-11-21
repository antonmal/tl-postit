class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :check_permissions, only: [:edit, :update]

  def index
    # uses two-parameters sorting via an array
    # negating the parameter values reverses sort order
    @posts = Post.all.sort_by { |post| [-post.votes_count, -post.updated_at.to_i] }

    respond_to do |format|
      format.json { render json: @posts }
      format.xml { render xml: @posts }
      format.html
    end
  end

  def show
    @comment = Comment.new

    respond_to do |format|
      format.json { render json: @post }
      format.xml { render xml: @post }
      format.html
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

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

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote for this once."
        end
        redirect_to :back
      end
      format.js
    end
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def check_permissions
    if logged_in?
      unless @post.creator == current_user || admin? || moderator?
        redirect_to root_path, alert: "You can only edit your own posts."
      end
    else
      please_login
    end
  end
end
