Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'client/sessions', registrations: 'client/registrations' }
    namespace :client, path: '' do
      resource 'profile'
      resources 'lottery'
      resources 'shop'
      resources :orders, only: [:new, :create] do
        member do
          post :buy
        end
      end
      resources 'addresses'
      resources 'tickets', only: [:create]
      resources 'invitations' do
        get 'generate_qr_code', on: :collection
      end
    end
    root 'client/homepage#index', as: 'client_root'
  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'admin/sessions' }, as: :admin
    root 'admin/homepage#index', as: 'admin_root'
    namespace :admin, path: '' do
      resources 'tickets', only: [:index]
      resources 'offers'
      resource 'profile'
      resources :items do
        member do
          post :start
          post :pause
          post :end
          post :cancel
        end
      end
      resources :winners do
        member do
          post :submit
          post :pay
          post :ship
          post :deliver
          post :publish
          post :remove_publish
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: [] do
        get 'provinces', to: 'regions#provinces'
      end

      resources :provinces, only: [] do
        get 'cities', to: 'provinces#cities'
      end

      resources :cities, only: [] do
        get 'barangays', to: 'cities#barangays'
      end
    end
  end
end


