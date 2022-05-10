require 'rails_helper'

RSpec.describe 'Investments::Position', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:treasury) { create(:treasury, account: account) }

  describe 'POST /investments/treasuries/:id/positions' do
    let(:new_position) do
      post investments_treasury_positions_path(treasury), params: { investments_position: valid_params }
    end
    let(:valid_params) { attributes_for(:position).merge(treasury_id: treasury.id) }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new position', :aggregate_failures do
        # puts '---------UPDATE---------', valid_params.inspect

        expect { new_position }.to change(Investments::Position, :count).by(1)
        expect(new_position).to be(302)
      end
    end

    context 'with invalid data' do
      let(:invalid_treasury) do
        post investments_treasury_positions_path(treasury), params: { investments_position: invalid_params }
      end
      let(:invalid_params) { { amount: 9550, shares: 23, kind: :buy, treasury_id: treasury.id } }

      it 'does not create a new position' do
        invalid_treasury

        expect { invalid_treasury }.not_to change(Investments::Treasury, :count)
      end
    end
  end

  # COntinue from here
  describe 'PUT /investments/treasuries/:id/positions/:id' do
    let(:position) { build_stubbed(:position, treasury: treasury) }
    let(:update_position) do
      put investments_treasury_position_path(treasury), params: {
        investments_treasury: {
          name: expected_name,
          account_id: account.id
        }, id: treasury.id
      }
    end

    context 'with valid data' do
      xit 'not ready yet' do
      end
    end

    context 'with invalid data' do
      xit 'not ready' do
      end
    end
  end
end
