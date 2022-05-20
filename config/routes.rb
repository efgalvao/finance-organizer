Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'accounts#index'
  devise_for :users
  get '/user/overview', to: 'users#overview'
  get '/user/summary', to: 'users#summary'

  resources :accounts do
    get 'month_transactions', on: :member
    get 'transactions', on: :member
    resources :balances, only: %i[edit destroy]
    resources :transactions, only: %i[edit]
  end

  scope module: 'investments', path: '/investments' do
    get '/investments/', to: 'investments#index'

    resources :stocks, controller: 'stock/stocks' do
      get 'current_price', on: :member
      resources :dividends, controller: 'stock/dividends', only: %i[index new create]
      resources :prices, controller: 'stock/prices', only: %i[new create]
      resources :shares, controller: 'stock/shares', only: %i[new create]
    end
  end

  namespace :investments do
    resources :treasuries, controller: 'treasury/treasuries' do
      resources :negotiations, only: %i[index new create], controller: 'treasury/negotiations'
      resources :positions, only: %i[new create], controller: 'treasury/positions'
    end
  end

  get '/transactions' => 'transactions#index'

  resources :balances, except: %i[edit destroy]

  resources :transactions, except: %i[edit]

  resources :categories

  resources :transferences, only: %i[new create index]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
