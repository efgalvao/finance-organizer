require 'rails_helper'

RSpec.describe Balance, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:balanceable) }
  end

  describe '.set_date' do
    let(:account) { create(:account) }
    let(:balance) { build(:balance, balanceable_type: 'Account', balanceable_id: account.id, date: nil) }

    it 'set the current date' do
      balance.save
      expect(balance.date).not_to be_nil
    end
  end
end
