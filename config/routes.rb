Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'client/sessions', registrations: 'client/registrations' }
    namespace :client, path: '' do
      resource :profile do
        get :order_history
        get :lottery_history
        get :winning_history
        get :invitation_history
        resources :claim, only: [:show, :update]
        resources :share, only: [:show, :update]
      end
      resources :share_page, only: [:index]
      resources :lottery
      resources :shop, only: [:index]
      resources :orders, only: [:new, :create] do
        post :cancel, on: :member
      end
      resources :addresses
      resources :tickets, only: [:create]
      resources :invitations do
        get :generate_qr_code, on: :collection
      end
    end
    root 'client/homepage#index', as: 'client_root'
  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'admin/sessions' }, as: :admin
    namespace :admin, path: '' do
      resources :categories, except: [:show]
      resources :invite_list, only: [:index]
      resources :news_tickers
      resources :banners
      resources :tickets, only: [:index]
      resources :orders, only: [:index] do
        member do
          post :pay
          post :cancel
        end
        collection do
          get 'clients/:client_id', to: 'orders#operate_balance', as: :operate_balance
          get 'clients/:client_id/increase/new', to: 'orders#new_increase', as: :new_increase
          post 'clients/:client_id/increase', to: 'orders#create_increase', as: :create_increase
          get 'clients/:client_id/deduct/new', to: 'orders#new_deduct', as: :new_deduct
          post 'clients/:client_id/deduct', to: 'orders#create_deduct', as: :create_deduct
          get 'clients/:client_id/bonus/new', to: 'orders#new_bonus', as: :new_bonus
          post 'clients/:client_id/bonus', to: 'orders#create_bonus', as: :create_bonus
          get 'clients/:client_id/member_level/new', to: 'orders#new_member_level', as: :new_member_level
          post 'clients/:client_id/member_level', to: 'orders#create_member_level', as: :create_member_level
        end
      end
      resources :member_levels
      resources :offers
      resource :profile, only: [:show, :edit, :update]
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
    root 'admin/homepage#index', as: 'admin_root'
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


