require 'rails_helper'

RSpec.describe Investments, type: :request do
  let(:user) { create(:user) }

  describe 'GET /investments' do
    context 'when logged in' do
      it 'can successfully access investments index page' do
        sign_in(user)

        get investments_path

        expect(response).to be_successful
      end
    end

    context 'when not logged in' do
      it 'can not access investments index page' do
        get investments_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
