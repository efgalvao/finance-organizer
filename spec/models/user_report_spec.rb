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

  describe '.set_date' do
    let(:user) { create(:user) }
    let(:user_report) { build(:user_report, date: nil) }
  end
end
