class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show update destroy]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @categories = policy_scope(Category).all
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to categories_path, notice: 'Category successfully removed.' }
        format.json { head :no_content }
      end
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
