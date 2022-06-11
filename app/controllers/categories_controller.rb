class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = policy_scope(Category).all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @category

    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @category

    redirect_to categories_path, notice: 'Category successfully removed.' if @category.destroy
  end

  def edit
    authorize @category
  end

  private

  def category_params
    params.require(:category).permit(:name, :user_id).merge(user_id: current_user.id)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
