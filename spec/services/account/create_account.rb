require 'rails_helper'

RSpec.describe Account::CreateAccount, type: :service do
  subject(:create_account) { described_class.new(params).call }
  let!(:user) { create(:user) }

  context 'with valid data' do
    let(:params) { attributes_for(:account).merge({ user_id: user.id }) }

    it 'creates an Account' do
      expect { subject }.to change(Account::Account, :count).by(1)
    end

    it 'creates a Balance' do
      expect { subject }.to change(Account::Balance, :count).by(1)
    end
  end

  context 'with invalid data' do
    let(:params) { attributes_for(:account) }

    it 'does not create an Account' do
      expect { subject }.not_to change(Account::Account, :count)
    end

    it 'does not create a Balance' do
      expect { subject }.not_to change(Account::Balance, :count)
    end
  end
end
