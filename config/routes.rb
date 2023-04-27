Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      resource :profile, only: [:show, :edit, :update]
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin do
      resources :users
    end
  end
end
