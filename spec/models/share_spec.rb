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

  # describe "scopes" do
  #   it "bought_this_month" do
  #     expect(Share.bought_this_month).to include(share_bougth_this_month)
  #     expect(Share.bought_this_month).not_to include(share_bought_last_month)
  #   end

  #   it "bought_last_month" do
  #     expect(Share.bought_this_month).to include(share_bought_last_month)
  #     expect(Share.bought_this_month).not_to include(share_bougth_this_month)
  #   end
    
  # end
  
end
