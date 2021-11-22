require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to define_enum_for(:kind) }
  end

  describe '.set_date' do
    let(:transaction) { build(:transaction, date: nil) }

    it 'set the current date' do
      transaction.save
      expect(transaction.date).not_to be_nil
    end
  end
end
