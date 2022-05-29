require 'rails_helper'

RSpec.describe Account::Account, type: :model do
  let(:account) { create(:account, balance: 100) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:balances) }
    it { is_expected.to have_many(:stocks) }
    it { is_expected.to have_many(:sender_transference) }
    it { is_expected.to have_many(:receiver_transference) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:balance) }
  end
end
