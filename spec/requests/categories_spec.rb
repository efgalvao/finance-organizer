require 'rails_helper'

RSpec.describe 'Category', type: :request do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }

  describe 'POST /categories' do
    let(:new_category) { post categories_path, params: { category: { name: Faker::Commerce.department } } }

    before { sign_in(user) }

    context 'with valid data' do
      it 'creates a new category' do
        expect { new_category }.to change(Category, :count).by(1)
      end

      it 'has flash notice' do
        new_category

        expect(flash[:notice]).to eq('Category successfully created.')
      end

      it 'redirects to categories_path' do
        new_category

        expect(response).to redirect_to categories_path
      end

      it 'also respond to json', :aggregate_failures do
        post categories_path(format: :json), params: { category: { name: Faker::Commerce.department } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid data' do
      let(:invalid_category) { build(:category) }

      it 'does not create a new category' do
        invalid_category.name = nil

        expect(invalid_category).not_to be_valid
      end

      it 'also respond to json', :aggregate_failures do
        post categories_path(format: :json), params: { category: { name: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
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
        expect(response).to redirect_to category_path(category)
        expect(response.request.flash[:notice]).to eq 'Category successfully updated.'
      end

      it 'also respond as json', :aggregate_failures do
        put category_path(category, format: :json), params: {
          category: {
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

      it 'does not update category' do
        put category_path(category), params: {
          category: {
            name: nil
          }
        }

        category.reload
        expect(category.name).not_to be_nil
      end

      it 'also respond to json', :aggregate_failures do
        put category_path(category, format: :json), params: { category: { name: nil } }

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
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
    let!(:new_category) { create(:category) }

    before { sign_in(user) }

    context 'when successfully' do
      it 'deletes a category', :aggregate_failures do
        expect { delete category_path(new_category) }.to change(Category, :count).by(-1)
        expect(flash[:notice]).to eq 'Category successfully removed.'
        expect(response).to redirect_to categories_path
      end
    end
  end

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
end
