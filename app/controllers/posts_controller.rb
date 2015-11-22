class PostsController < ApplicationController
  PER_PAGE = 3

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :check_permissions, only: [:edit, :update]

  def index
    @page = (params[:page] || 1).to_i
    @total_pages = (Post.all.size / PER_PAGE.to_f).ceil
    @posts =  Post.sorted_by_votes.limit(PER_PAGE).offset((@page - 1) * PER_PAGE)

    respond_to do |format|
      format.json { render json: @posts }
      format.xml { render xml: @posts }
      format.html
    end
  end

  def show
    @comment = Comment.new

    @page = (params[:page] || 1).to_i
    @total_pages = (@post.comments.size / PER_PAGE.to_f).ceil
    @comments = @post.comments.sorted_by_votes.limit(PER_PAGE).offset((@page - 1) * PER_PAGE)

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
