module Investments
  class Negotiation < ApplicationRecord
    belongs_to :treasury, touch: true

    enum kind: { buy: 0, sell: 1 }

    monetize :amount_cents

    validates :kind, :date, :treasury, presence: true

    delegate :user, to: :'treasury.account'
  end
end
