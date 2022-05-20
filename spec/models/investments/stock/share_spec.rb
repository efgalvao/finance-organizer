require 'rails_helper'

RSpec.describe Investments::Stock::Share, type: :model do
  # let(:user) { create(:user) }
  # let(:stock) { create(:stock, user_id: user_id) }
  let(:share) { create(:share) }
  let(:share_bougth_this_month) { create(:share, date: DateTime.current) }
  let(:share_bought_last_month) { create(:share, datecurrent - 1.month) }

  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:invested) }
  end
end
