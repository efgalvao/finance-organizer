require 'rails_helper'

RSpec.describe 'Share', type: :request do
  let(:user) { create(:user) }
  let!(:share) { create(:share) }

  describe 'GET /shares/:id/edit' do
    context 'when logged in' do
      it 'can successfully access an share edit page' do
        sign_in(user)

        get edit_share_path(share)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a share edit page' do
        get edit_share_path(share)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /shares/:id' do
    context 'when logged' do
      let(:expected_value) { 1_000 }

      before { sign_in(user) }

      it 'can successfully update a share', :aggregate_failures do
        put share_path(share), params: {
          share: {
            aquisition_value: expected_value
          }
        }

        share.reload
        expect(share.aquisition_value_cents).to eq(expected_value * 100)
        expect(response).to redirect_to share_path(share)
        expect(response.request.flash[:notice]).to eq 'Share successfully updated.'
      end

      it 'also respond as json', :aggregate_failures do
        put share_path(share, format: :json), params: {
          share: {
            aquisition_value: expected_value
          }
        }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(response.body).to match((expected_value * 100).to_json)
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update share' do
        put share_path(share), params: {
          share: {
            stock_id: nil
          }
        }

        share.reload
        expect(share.stock_id).not_to be_nil
      end

      it 'also respond to json', :aggregate_failures do
        put share_path(share, format: :json), params: { share: { stock_id: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with unauthenticated request' do
      it 'can not update a share' do
        put share_path(share), params: {
          share: {
            share: 10_000
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /shares' do
    let!(:stock) { create(:stock) }
    let!(:params) { { stock_id: stock.id, aquisition_value: 1_000 } }
    let(:new_share) { post shares_path, params: { share: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Share' do
        expect { new_share }.to change(Share, :count).by(1)
      end

      it 'has flash notice' do
        new_share

        expect(flash[:notice]).to eq('Share successfully created.')
      end

      it 'redirects to shares_path' do
        new_share

        expect(response).to redirect_to shares_path
      end

      it 'also respond to json', :aggregate_failures do
        post shares_path(format: :json), params: { share: params }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      it 'does not create a new share' do
        post shares_path(format: :json), params: { share: { stock_id: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'also respond to json', :aggregate_failures do
        post shares_path(format: :json), params: { share: { stock_id: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /shares/:id   ' do
    let!(:new_share) { create(:share) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a share', :aggregate_failures do
        expect { delete share_path(new_share) }.to change(Share, :count).by(-1)
        expect(flash[:notice]).to eq 'Share successfully removed.'
        expect(response).to redirect_to shares_path
      end
    end
  end

  describe 'GET /shares' do
    context 'when logged in' do
      it 'can successfully access shares index page' do
        sign_in(user)

        get shares_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a shares index page' do
        get shares_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
