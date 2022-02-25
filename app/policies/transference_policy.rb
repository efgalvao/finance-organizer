class TransferencePolicy < ApplicationPolicy
  attr_reader :user, :transference

  def initialize(user, transference)
    super
    @user = user
    @transference = transference
  end

  def index?
    transference
  end

  def show?
    transference_user?
  end

  def update?
    transference_user?
  end

  def edit?
    transference_user?
  end

  def destroy?
    transference_user?
  end

  class Scope < Scope
    def resolve
      Transference.where(user: @user)
    end
  end
end
