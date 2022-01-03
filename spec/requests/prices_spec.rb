require 'rails_helper'

RSpec.describe 'Price', type: :request do
  let(:user) { create(:user) }
  let!(:price) { create(:price) }

  describe 'GET /stock/id:/prices/:id/edit' do
    context 'when logged in' do
      it 'can successfully access an price edit page' do
        sign_in(user)

        get edit_stock_price_path(price, stock_id: price.stock_id)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a price edit page' do
        get edit_stock_price_path(price, stock_id: price.stock_id)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /prices/:id' do
    context 'when logged' do
      let(:expected_price) { 1_000 }

      before { sign_in(user) }

      it 'can successfully update a price', :aggregate_failures do
        put price_path(price), params: {
          price: {
            price: expected_price
          }
        }

        price.reload
        expect(price.price_cents).to eq(expected_price * 100)
        expect(response).to redirect_to price_path(price)
        expect(response.request.flash[:notice]).to eq 'Price successfully updated.'
      end

      it 'also respond as json', :aggregate_failures do
        put price_path(price, format: :json), params: {
          price: {
            price: expected_price
          }
        }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(expected_price.to_json)
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update price', :aggregate_failures do
        put price_path(price, format: :json), params: { price: { stock_id: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with unauthenticated request' do
      it 'can not update a price' do
        put price_path(price), params: {
          price: {
            price: 10_000
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /prices' do
    let!(:stock) { create(:stock) }
    let!(:params) { { stock_id: stock.id, price: 1_000 } }
    let(:new_price) { post prices_path, params: { price: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Price' do
        expect { new_price }.to change(Price, :count).by(1)
      end

      it 'has flash notice' do
        new_price

        expect(flash[:notice]).to eq('Price successfully created.')
      end

      it 'redirects to prices_path' do
        new_price

        expect(response).to redirect_to prices_path
      end

      it 'also respond to json', :aggregate_failures do
        post prices_path(format: :json), params: { price: params }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      let(:invalid_price) { build(:price) }

      it 'does not create a new price' do
        invalid_price.stock_id = nil

        expect(invalid_price).not_to be_valid
      end

      it 'also respond to json', :aggregate_failures do
        post prices_path(format: :json), params: { price: { stock_id: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /stocks/:stock_id/prices/:id   ' do
    let!(:new_price) { create(:price) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a price', :aggregate_failures do
        expect { delete stock_price_path(new_price, stock_id: new_price.stock.id) }.to change(Price, :count).by(-1)
        expect(flash[:notice]).to eq 'Price successfully removed.'
        expect(response).to redirect_to prices_path
      end
    end
  end

  describe 'GET /prices' do
    context 'when logged in' do
      it 'can successfully access prices index page' do
        sign_in(user)

        get prices_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a prices index page' do
        get prices_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
