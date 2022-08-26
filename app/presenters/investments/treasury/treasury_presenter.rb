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

      private

      def semester_positions
        positions.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
      end
    end
  end
end
