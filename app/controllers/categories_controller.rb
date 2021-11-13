class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'Category sucessfully created'
    else
      render :new
    end
  end

  def index
    @categories = policy_scope(Category).all
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category suscessfuly updated'
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      redirect_to categories_path, notice: 'Category sucessfully deleted'
    else
      render :delete
    end
  end

  def show; end

  private

  def category_params
    params.require(:category).permit(:name, :user_id).merge(user_id: current_user.id)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
