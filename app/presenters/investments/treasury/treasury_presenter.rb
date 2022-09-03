module Investments
  module Treasury
    class TreasuryPresenter < SimpleDelegator
      def last_semester_positions
        grouped_positions = {}
        semester_positions.each do |position|
          grouped_positions[position.date.strftime('%B %d, %Y').to_s] = position.amount.to_f
        end
        grouped_positions
      end

      def ordered_positions
        positions.order(date: :desc).limit(6)
      end

      def ordered_negotiations
        negotiations.order(date: :desc).limit(6)
      end

      private

      def semester_positions
        positions.order(date: :desc).limit(12)
      end
    end
  end
end
