require 'rails_helper'

RSpec.describe Dividend, type: :model do
  describe 'associtaions' do
    it { is_expected.to belong_to(:stock) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:value) }
  end
end
