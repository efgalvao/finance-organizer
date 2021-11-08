Rails.application.routes.draw do
  root to: "accounts#index"
  devise_for :users

  resources :accounts do
    get '/summary', to: 'accounts#summary'
    get '/transactions', to: 'accounts#transactions_history'
    resources :balances, only: %i[edit destroy]
    resources :transactions, only: %i[edit destroy]
  end

  resources :stocks do
    get '/summary', to: 'stocks#summary'
    resources :dividends, only: [:destroy]
    resources :prices, only: %i[edit destroy]
  end

  get '/transactions' => "transactions#index"

  resources :shares

  resources :dividends, except: [:destroy]

  resources :prices, except: %i[edit destroy]

  resources :charts, only: %i[index]

  resources :balances, except: %i[edit destroy]

  resources :transactions, except: %i[edit destroy]

  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
