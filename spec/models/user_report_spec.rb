require 'rails_helper'

RSpec.describe UserReport, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:savings) }
    it { is_expected.to monetize(:stocks) }
    it { is_expected.to monetize(:incomes) }
    it { is_expected.to monetize(:expenses) }
    it { is_expected.to monetize(:dividends) }
    it { is_expected.to monetize(:card_expenses) }
    it { is_expected.to monetize(:invested) }
    it { is_expected.to monetize(:final) }
    it { is_expected.to monetize(:total) }
  end
end
