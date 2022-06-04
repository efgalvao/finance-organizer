require 'rails_helper'

RSpec.describe Category, type: :request do
  let(:user) { create(:user) }
  let!(:category) { create(:category, user: user) }

  describe 'GET /categories' do
    context 'when logged in' do
      it 'can successfully access categories index page' do
        sign_in(user)

        get categories_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a balances index page' do
        get categories_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /categories/new' do
    context 'when logged in' do
      it 'can successfully access new category' do
        sign_in(user)

        get new_category_path

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a new category page' do
        get new_category_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /categories' do
    let(:new_category) { post categories_path, params: { category: { name: Faker::Commerce.department }, user: user } }

    before { sign_in(user) }

    context 'with valid data' do
      let(:params) { attributes_for(:category) }

      it 'creates a new category' do
        expect { new_category }.to change(described_class, :count).by(1)
      end

      it 'has flash notice' do
        new_category

        expect(flash[:notice]).to eq('Category successfully created.')
      end

      it 'redirects to categories_path' do
        new_category

        expect(response).to redirect_to categories_path
      end
    end

    context 'with invalid data' do
      let(:invalid_category) { build(:category) }

      it 'does not create a new category' do
        invalid_category.name = nil

        expect(invalid_category).not_to be_valid
      end
    end
  end

  describe 'GET /categories/:id/edit' do
    context 'when logged in' do
      it 'can successfully access a category edit page' do
        sign_in(user)

        get edit_category_path(category)

        expect(response).to be_successful
      end
    end

    context 'with unauthenticated request' do
      it 'cannot access a category edit page' do
        get edit_category_path(category)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT /cateories/:id' do
    context 'when logged' do
      let(:expected_name) { Faker::Books::Dune.title }

      before { sign_in(user) }

      it 'can successfully update a category', :aggregate_failures do
        put category_path(category), params: {
          category: {
            name: expected_name
          }
        }

        category.reload
        expect(category.name).to eq(expected_name)
        expect(response).to redirect_to categories_path
        expect(response.request.flash[:notice]).to eq 'Category successfully updated.'
      end
    end

    context 'with invalid data' do
      before { sign_in(user) }

      it 'does not update category' do
        put category_path(category), params: {
          category: {
            name: nil
          }
        }

        category.reload
        expect(category.name).not_to be_nil
      end
    end

    context 'with unauthenticated request' do
      it 'cannot update a category' do
        put category_path(category), params: {
          category: {
            name: Faker::Books::Dune.title
          }
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE /category/id:/delete' do
    let!(:new_category) { create(:category, user: user) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a category', :aggregate_failures do
        expect { delete category_path(new_category) }.to change(described_class, :count).by(-1)
        expect(flash[:notice]).to eq 'Category successfully removed.'
        expect(response).to redirect_to categories_path
      end
    end
  end
end
