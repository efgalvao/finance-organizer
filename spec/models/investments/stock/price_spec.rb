require 'rails_helper'

RSpec.describe Investments::Stock::Price, type: :model do
  describe 'associtaions' do
    it { is_expected.to belong_to(:stock) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:value) }
  end
end
