module Investments
  module Treasury
    class Treasury < ApplicationRecord
      has_many :positions, dependent: :destroy
      has_many :negotiations, dependent: :destroy
      belongs_to :account, class_name: 'Account::Account', touch: true

      validates :name, :account, presence: true

      monetize :invested_value_cents
      monetize :current_value_cents
      monetize :released_value_cents

      delegate :user, :name, to: :account, prefix: 'account'
    end
  end
end
