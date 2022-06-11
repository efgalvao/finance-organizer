require 'rails_helper'

RSpec.describe Account::Transaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to define_enum_for(:kind) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:value) }
  end
end
