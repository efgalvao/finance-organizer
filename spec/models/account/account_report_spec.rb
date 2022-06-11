require 'rails_helper'

RSpec.describe Account::AccountReport, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:savings) }
    it { is_expected.to monetize(:stocks) }
    it { is_expected.to monetize(:total) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_id) }
  end
end
