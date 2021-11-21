require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to have_many(:dividends).dependent(:destroy) }
    it { is_expected.to have_many(:shares).dependent(:destroy) }
    it { is_expected.to have_many(:prices).dependent(:destroy) }
  end
end
