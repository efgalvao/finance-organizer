# frozen_string_literals: true

module UserReports
  module Commands
    class UpdateUserReport < ApplicationService
      def initialize(report:, params:)
        @report = report
        @params = params
        @date = Time.zone.today
      end

      def self.call(report:, params:)
        new(report: report, params: params).call
      end

      def call
        update_user_report
      end

      private

      attr_reader :report, :params, :date

      def update_user_report
        report.update(new_attributes)
      end

      def dividends
        params.fetch(:dividends_cents, 0) + report.dividends_cents
      end

      def new_attributes
        params.merge!(
          {
            date: date,
            dividends_cents: dividends
          }
        )
      end
    end
  end
end
