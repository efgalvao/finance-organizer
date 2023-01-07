require 'rails_helper'

RSpec.describe Investments::Stock::Share, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:invested) }
  end
end
