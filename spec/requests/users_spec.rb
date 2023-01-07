require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:user) { create(:user) }

  describe 'GET /summary' do
    context 'when logged in' do
      let!(:user) { create(:user) }

      it 'can successfully access an user summary page' do
        sign_in(user)

        get user_summary_path

        expect(response).to be_successful
      end
    end

    context 'when not logged in' do
      it 'can not access an user summary page' do
        get user_summary_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /overview' do
    context 'when logged in' do
      it 'can successfully access an user summary page' do
        sign_in(user)

        get user_overview_path

        expect(response).to be_successful
      end
    end

    context 'when not logged in' do
      it 'can not access an user summary page' do
        get user_overview_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
