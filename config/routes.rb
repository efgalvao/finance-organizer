Rails.application.routes.draw do
  root to: "accounts#index"
  devise_for :users
  get '/user/overview', to: 'users#overview'
  get '/user/summary' => "users#summary"

  resources :accounts do
    get '/summary', to: 'accounts#summary'
    get '/transactions', to: 'accounts#transactions_history'
    resources :balances, only: %i[edit destroy]
    resources :transactions, only: %i[edit]
  end

  resources :stocks do
    get '/summary', to: 'stocks#summary'
    get '/current_price', to: 'prices#current_price'
    resources :dividends, only: [:destroy]
    resources :prices, only: %i[edit destroy]
  end

  get '/transactions' => "transactions#index"

  resources :shares

  resources :dividends, except: [:destroy]

  resources :prices, except: %i[edit destroy]

  resources :balances, except: %i[edit destroy]

  resources :transactions, except: %i[edit]

  resources :categories

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
