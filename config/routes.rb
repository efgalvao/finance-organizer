Rails.application.routes.draw do
  root to: "accounts#index"
  devise_for :users

  resources :accounts do
    get '/summary', to: 'accounts#summary'
    resources :balances, only: %i[edit destroy]
  end

  resources :balances, except: %i[edit destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
