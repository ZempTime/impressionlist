Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lists
  resources :connections do
    scope module: "connections" do
      resource :approvals, only: :create
      resource :treasures, only: :create
      resource :denies, only: :create
    end
  end

  root to: "lists#show"
end
