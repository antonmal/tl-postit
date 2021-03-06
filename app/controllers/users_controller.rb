class UsersController < ApplicationController
  PER_PAGE = 3

  before_action :set_user, only: [:show, :edit, :update]
  before_action :check_permissions, only: [:edit, :update]

  def show
    @posts_or_comments = (params[:show] || :posts).to_sym
    case @posts_or_comments
    when :posts
      @page = (params[:page] || 1).to_i
      @total_pages = (@user.posts.size / PER_PAGE.to_f).ceil
      @posts = @user.posts.sorted_by_votes.limit(PER_PAGE).offset((@page - 1) * PER_PAGE)
    when :comments
      @page = (params[:page] || 1).to_i
      @total_pages = (@user.comments.size / PER_PAGE.to_f).ceil
      @comments = @user.comments.sorted_by_votes.limit(PER_PAGE).offset((@page - 1) * PER_PAGE)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: 'Your account was created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Your profile was updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :timezone, :phone)
  end

  def check_permissions
    if logged_in?
      unless @user == current_user || admin?
        redirect_to current_user, alert: "You can only edit your own profile."
      end
    else
      please_login
    end
  end
end
