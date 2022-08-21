# frozen_string_literals: true

module UserReports
  module Commands
    class UpdateUserReport < ApplicationService
      def initialize(user_id:, params:)
        @user_id = user_id
        @params = params
        @date = set_date
      end

      def self.call(user_id:, params:)
        new(user_id: user_id, params: params).call
      end

      def call
        update_user_report
      end

      private

      attr_reader :user_id, :params, :date

      def update_user_report
        report.update(new_attributes)
      end

      def report
        @report ||= user.reports.where(date: date.beginning_of_month...date.end_of_month).first_or_initialize
      end

      def user
        @user ||= User.find(user_id)
      end

      def set_date
        return Time.zone.today if params.fetch(:date) == ''

        DateTime.parse(params.fetch(:date))
      end

      def dividends
        params.fetch(:dividends_cents, 0) + report.dividends_cents
      end

      def new_attributes
        {
          date: date,
          dividends_cents: dividends
        }
      end
    end
  end
end
