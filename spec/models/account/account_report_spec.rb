require 'rails_helper'

RSpec.describe Account::AccountReport, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:incomes) }
    it { is_expected.to monetize(:expenses) }
    it { is_expected.to monetize(:invested) }
    it { is_expected.to monetize(:dividends) }
    it { is_expected.to monetize(:final) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_id) }
  end
end
