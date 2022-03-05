class TransferencePolicy < ApplicationPolicy
  attr_reader :user, :transference

  def initialize(user, transference)
    super
    @user = user
    @transference = transference
  end

  class Scope < Scope
    def resolve
      Transference.where(user: @user)
    end
  end
end
