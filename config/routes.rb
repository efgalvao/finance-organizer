Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'account/accounts#index'
  devise_for :users
  get '/user/overview', to: 'users#overview'
  get '/user/summary', to: 'users#summary'

  scope module: 'account' do
    get '/cards', to: 'accounts#cards'
    resources :accounts do
      resources :transactions, only: %i[index new create edit update]
    end
  end

  scope module: 'investments', path: '/investments' do
    get '/', to: 'investments#index'

    resources :stocks, controller: 'stock/stocks' do
      get 'current_price', on: :member
      resources :dividends, controller: 'stock/dividends', only: %i[index new create]
      resources :prices, controller: 'stock/prices', only: %i[new create]
      resources :shares, controller: 'stock/shares', only: %i[new create]
    end

    resources :treasuries, controller: 'treasury/treasuries' do
      get 'release_form', on: :member
      post 'release', on: :member
      resources :negotiations, only: %i[index new create], controller: 'treasury/negotiations'
      resources :positions, only: %i[new create], controller: 'treasury/positions'
    end
  end

  resources :transferences, only: %i[index new create]

  resources :categories, except: %i[show]

  get '/transactions/debit', to: 'transactions#debit'
  get '/transactions/credit', to: 'transactions#credit'
  get '/transactions/income', to: 'transactions#income'
  get '/transactions/invoice', to: 'transactions#invoice'
  post '/transactions/invoice_payment', to: 'transactions#invoice_payment'
  post '/transactions', to: 'transactions#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
