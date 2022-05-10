require 'rails_helper'

RSpec.describe Investments::Treasury::Negotiation, type: :model do
  describe 'associtaions' do
    it { is_expected.to belong_to(:treasury) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:amount) }
  end
end
