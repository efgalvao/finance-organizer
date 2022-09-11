module UserReports
  module Commands
    class CreateUserReport < ApplicationService
      def initialize(user_id:, params:)
        @user_id = user_id
        @params = params
      end

      def self.call(user_id:, params:)
        new(user_id: user_id, params: params).call
      end

      def call
        create_user_report
      end

      private

      attr_reader :user_id, :params

      def create_user_report
        user.reports.create!(params)
      end

      def user
        @user ||= User.find(user_id)
      end
    end
  end
end
