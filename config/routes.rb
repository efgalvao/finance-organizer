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

  namespace :investments do
    get '/', to: 'investments#index'
    resources :stocks do
      get 'summary', on: :member
      get '/current_price', to: 'prices#current_price'
      resources :dividends, only: %i[edit destroy]
      resources :prices, only: %i[edit destroy]
    end

    resources :treasuries do
      resources :negotiations, only: %i[index new create]
      resources :positions, only: %i[new create]
    end
  end

  get '/transactions' => 'transactions#index'

  resources :shares, except: [:show]

  resources :dividends, except: %i[edit destroy]

  resources :prices, except: %i[show edit destroy]

  resources :balances, except: %i[edit destroy]

  resources :transactions, except: %i[edit]

  resources :categories

  resources :transferences, only: %i[new create index]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
