require 'rails_helper'

RSpec.describe 'Investments::Treasury::Position', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:treasury) { create(:treasury, account: account) }

  describe 'POST /investments/treasuries/:id/positions' do
    subject(:post_position) do
      post treasury_positions_path(treasury), params: { position: params }
    end

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:position).merge(treasury_id: treasury.id) }

      it 'creates a new position', :aggregate_failures do
        expect { post_position }.to change(Investments::Treasury::Position, :count).by(1)
        expect(post_position).to be(302)
      end
    end

    context 'with invalid data' do
      let(:params) { { amount: 9550, shares: 23, kind: :buy, treasury_id: treasury.id } }

      it 'does not create a new position' do
        post_position

        expect { post_position }.not_to change(Investments::Treasury::Position, :count)
      end
    end
  end
end
