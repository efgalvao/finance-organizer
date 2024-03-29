require 'rails_helper'

RSpec.describe Account::CreateAccount, type: :service do
  subject(:create_account) { described_class.new(params).call }

  let!(:user) { create(:user) }

  context 'with valid data' do
    let(:params) { attributes_for(:account).merge({ user_id: user.id }) }

    it 'creates an Account' do
      expect { create_account }.to change(Account::Account, :count).by(1)
    end
  end

  context 'with invalid data' do
    let(:params) { attributes_for(:account) }

    it 'does not create an Account' do
      expect { create_account }.not_to change(Account::Account, :count)
    end
  end
end
