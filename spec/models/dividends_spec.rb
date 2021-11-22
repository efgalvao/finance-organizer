require 'rails_helper'

RSpec.describe Dividend, type: :model do
  describe 'associtaions' do
    it { is_expected.to belong_to(:stock) }
  end

  describe '.set_date' do
    let(:dividend) { build(:dividend, date: nil) }

    it 'set the current date' do
      dividend.save
      expect(dividend.date).not_to be_nil
    end
  end
end
