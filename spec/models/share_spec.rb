require 'rails_helper'

RSpec.describe Share, type: :model do
  # let(:user) { create(:user) }
  # let(:stock) { create(:stock, user_id: user_id) }
  let(:share) { create(:share) }
  let(:share_bougth_this_month) { create(:share, aquisition_date: DateTime.current) }
  let(:share_bought_last_month) { create(:share, aquisition_date: DateTime.current - 1.month) }

  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
  end

  describe '.set_date' do
    let(:share) { build(:share, aquisition_date: nil) }

    it 'set the current date' do
      share.save
      expect(share.aquisition_date).not_to be_nil
    end
  end
end
