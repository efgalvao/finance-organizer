class CategoryPolicy < ApplicationPolicy
  attr_reader :user, :category

  def initialize(user, category)
    super
    @user = user
    @category = category
  end

  def index?
    category
  end

  def show?
    category_user?
  end

  def update?
    category_user?
  end

  def edit?
    category_user?
  end

  def destroy?
    category_user?
  end

  class Scope < Scope
    def resolve
      Category.where(user_id: @user.id)
    end
  end
end
