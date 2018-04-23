Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "posts#index"

  resources :posts do
    resources :replies, only: [:index, :create, :update, :destroy]

    collection do
      get :replies_count
      get :last_replied_at
      get :viewed_count
    end
  end

  resources :favorites, only: [:create, :destroy]

  resources :friendships, only: [:index, :create, :update, :destroy]

  resources :views, only: [:create]

  resources :users, only: [:show, :edit, :update] do
    member do
      get :my_post
      get :my_comment
      get :my_collect
      get :my_draft
      get :my_friend
    end
  end

  resources :feeds, only: [:index]

  namespace :admin do
    resources :categories, except: [:show, :new, :edit]
    resources :users, only: :index do

      member do
        post :add_admin
      end
    end
    root "categories#index"
  end
end
