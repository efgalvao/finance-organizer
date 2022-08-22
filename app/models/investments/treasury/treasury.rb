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

      def last_semester_positions
        grouped_positions = {}
        semester_positions.each do |position|
          grouped_positions[position.date.strftime('%B %d, %Y').to_s] = position.amount.to_f
        end
        grouped_positions
      end

      private

      def semester_positions
        positions.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
      end
    end
  end
end
