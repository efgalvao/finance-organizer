module Transferences
  class BuildTransferences
    def initialize(content, user_id)
      @content = content
      @user_id = user_id
    end

    def self.call(content, user_id)
      new(content, user_id).call
    end

    def call
      build_transferences
    end

    private

    attr_reader :content, :user_id

    def build_transferences
      content.map do |transference|
        build_transference(transference)
      end
    end

    def build_transference(transference)
      {
        "sender_id": account_id(transference[:sender]),
        "receiver_id": account_id(transference[:receiver]),
        "date": transference[:date],
        "amount": transference[:amount],
        "user_id": user_id
      }
    end

    def account_id(account_name)
      Account::Account.find_by(name: account_name)&.id
    end
  end
end
