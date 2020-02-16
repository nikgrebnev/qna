Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :voteup
      post :votedown
      post :votecancel
    end
  end
  resources :questions, concerns: %i[votable], shallow: true do
    resources :answers, concerns: %i[votable], shallow: true do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :rewards, only: :index

  root to: "questions#index"
end
