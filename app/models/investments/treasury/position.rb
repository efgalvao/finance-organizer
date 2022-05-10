module Investments
  module Treasury
    class Position < ApplicationRecord
      belongs_to :treasury, touch: true

      monetize :amount_cents

      validates :amount_cents, :date, :treasury, presence: true
    end
  end
end
