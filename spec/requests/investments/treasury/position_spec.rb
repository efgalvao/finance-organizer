require 'rails_helper'

RSpec.describe 'Investments::Treasury::Position', type: :request do
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
        expect { new_position }.to change(Investments::Treasury::Position, :count).by(1)
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

        expect { invalid_treasury }.not_to change(Investments::Treasury::Position, :count)
      end
    end
  end
end
