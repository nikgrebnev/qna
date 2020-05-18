Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :voteup
      post :votedown
      post :votecancel
    end
  end

  concern :commentable do
    resource :comments, only: %i[create update destroy], shallow: true
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
