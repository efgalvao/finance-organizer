class SharePolicy < ApplicationPolicy
  attr_reader :user, :share

  def initialize(user, share)
    super
    @user = user
    @share = share
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def edit?
    owner?
  end

  class Scope < Scope
    def resolve
      @scope.where(user_id: @user.id)
    end
  end

  private

  def owner?
    record.user == user
  end
end
