require 'rails_helper'

RSpec.describe Investments::Treasury, type: :model do
  describe 'associtaions' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:invested_value) }
    it { is_expected.to monetize(:current_value) }
  end
end
