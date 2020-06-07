require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sdk'

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :voteup
      post :votedown
      post :votecancel
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end

  concern :commentable do
    resource :comments, only: %i[create update destroy], shallow: true
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch :make_best, on: :member
    end
    resources :subscriptions, only: %i[create destroy]
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :search, only: :index

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
