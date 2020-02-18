Rails.application.routes.draw do

  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root 'users#my_portfolio'# 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_portfolio_update', to: 'users#my_portfolio_update'
  get 'search_stock', to: 'stocks#search'
  get 'search', to: 'search#search'
  get 'my_friends', to: 'users#my_friends'
  get 'search_friend', to: 'users#search'
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show]
end
