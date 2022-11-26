require 'rails_helper'

RSpec.describe Transference, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:sender) }
    it { is_expected.to belong_to(:receiver) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to monetize(:value) }
  end
end
