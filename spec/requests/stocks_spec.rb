require 'rails_helper'

RSpec.describe 'Stock', type: :request do
  let(:user) { create(:user) }
  let!(:stock) { create(:stock) }

  describe 'GET /stocks/:id/edit' do
    context 'when logged in' do
      it 'can successfully access an stock edit page' do
        sign_in(user)

        get edit_stock_path(stock)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a stock edit page' do
        get edit_stock_path(stock)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /stocks/:id' do
    context 'when logged' do
      let(:expected_name) { 'NFLX' }

      before { sign_in(user) }

      it 'can successfully update a stock', :aggregate_failures do
        put stock_path(stock), params: {
          stock: {
            name: expected_name
          }
        }

        stock.reload
        expect(stock.name).to eq(expected_name)
        expect(response).to redirect_to stock_path(stock)
        expect(response.request.flash[:notice]).to eq 'Stock successfully updated.'
      end

      it 'also respond as json', :aggregate_failures do
        put stock_path(stock, format: :json), params: {
          stock: {
            name: expected_name
          }
        }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(expected_name.to_json)
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update stock' do
        put stock_path(stock), params: {
          stock: {
            name: nil
          }
        }

        stock.reload
        expect(stock.name).not_to be_nil
      end

      it 'also respond to json', :aggregate_failures do
        put stock_path(stock, format: :json), params: { stock: { name: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with unauthenticated request' do
      it 'can not update a stock' do
        put stock_path(stock), params: {
          stock: {
            name: 'NFLX'
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /stocks' do
    let!(:account) { create(:account) }
    let!(:params) { { name: 'SLFI', account_id: account.id } }
    let(:new_stock) { post stocks_path, params: { stock: params } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new Stock' do
        expect { new_stock }.to change(Stock, :count).by(1)
      end

      it 'has flash notice' do
        new_stock

        expect(flash[:notice]).to eq('Stock successfully created.')
      end

      it 'redirects to stocks_path' do
        new_stock

        expect(response).to redirect_to stock_path(Stock.find_by(name: 'SLFI'))
      end

      it 'also respond to json', :aggregate_failures do
        post stocks_path(format: :json), params: { stock: params }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      it 'does not create a new stock' do
        post stocks_path(format: :json), params: { stock: { name: nil } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'also respond to json', :aggregate_failures do
        post stocks_path(format: :json), params: { stock: { name: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /stocks/:id   ' do
    let!(:new_stock) { create(:stock) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a stock', :aggregate_failures do
        expect { delete stock_path(new_stock) }.to change(Stock, :count).by(-1)
        expect(flash[:notice]).to eq 'Stock successfully removed.'
        expect(response).to redirect_to stocks_path
      end
    end
  end

  describe 'GET /stocks' do
    context 'when logged in' do
      it 'can successfully access stocks index page' do
        sign_in(user)

        get stocks_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a stocks index page' do
        get stocks_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
