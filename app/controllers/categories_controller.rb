class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.all order: 'name DESC'

    respond_to do |format|
      format.json { render json: @categories }
      format.xml { render xml: @categories }
      format.html
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @category }
      format.xml { render xml: @category }
      format.html
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category created successfully."
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category updated successfully.'
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    if @category.posts.any?
      flash[:warning] = "Category cannot be deleted, because " \
                        "#{@category.posts.size} posts use it. " \
                        "Remove the category from those posts first."
      redirect_to @category
    else
      @category.destroy
      redirect_to categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find_by(slug: params[:id])
  end

  def require_admin
    if logged_in?
      unless admin?
        redirect_to root_path, alert: 'You are not authorized to create or edit categories.'
      end
    else
      please_login
    end
  end
end
