require 'rails_helper'

RSpec.describe UserReport, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '.set_date' do
    let(:user) { create(:user) }
    let(:user_report) { build(:user_report, date: nil) }

    it 'set the current date' do
      user_report.save
      expect(user_report.date).not_to be_nil
    end
  end
end
