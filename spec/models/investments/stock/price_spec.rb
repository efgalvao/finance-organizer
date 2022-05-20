require 'rails_helper'

RSpec.describe Investments::Stock::Price, type: :model do
  describe 'associtaions' do
    it { is_expected.to belong_to(:stock) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:value) }
  end

  describe '.set_date' do
    let(:price) { build(:price, date: nil) }

    it 'set the current date' do
      price.save
      expect(price.date).not_to be_nil
    end
  end
end
