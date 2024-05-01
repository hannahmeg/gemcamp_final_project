Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  constraints(ClientDomainConstraint.new) do
    devise_scope :user do
      get 'sign_in', to: 'clients/sessions#new'
      post 'sign_in', to: 'clients/sessions#create'
      get 'sign_up', to: 'clients/registrations#new'
      post 'sign_up', to: 'clients/registrations#create'
    end
    root 'home#index', as: 'client_root'
  end

  constraints(AdminDomainConstraint.new) do
      devise_scope :user do
        get 'admin/sign_in', to: 'admins/sessions#new', as: 'new_admin_session'
        post 'admin/sign_in', to: 'admins/sessions#create'
      end
  end
  root 'dashboard#index', as: 'admin_root'
end
