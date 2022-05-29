require 'rails_helper'

RSpec.describe Account::Balance, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:balance) }
  end
end
