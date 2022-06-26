require 'rails_helper'

RSpec.describe UserReport, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:savings) }
    it { is_expected.to monetize(:stocks) }
    it { is_expected.to monetize(:total) }
  end
end
