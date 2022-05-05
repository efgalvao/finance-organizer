module Investments
  class Treasury < ApplicationRecord
    has_many :positions, dependent: :destroy
    has_many :negotiations, dependent: :destroy
    belongs_to :account, touch: true

    validates :name, :account, presence: true

    monetize :invested_value_cents
    monetize :current_value_cents

    delegate :user, :name, to: :account, prefix: 'account'

    def name_with_account
      "#{name} (#{account.name})"
    end
  end
end
