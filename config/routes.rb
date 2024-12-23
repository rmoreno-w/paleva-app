Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  #get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  #get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "welcome#index"

  resources :restaurants, only: [ :new, :create ] do
    resources :restaurant_operating_hours, only: [ :index, :new, :create ]
    resources :tags, only: [ :new, :create ]
    get 'exclude_tag', to: 'tags#exclude'
    delete 'destroy_tag', to: 'tags#destroy'

    resources :dishes, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
      post 'deactivate', on: :member
      post 'activate', on: :member
      resources :servings, only: [ :new, :create, :edit, :update ] do 
        get 'history', to: 'servings#history'
      end
      get 'new_tag_assignment', to: 'tags#new_assignment'
      post 'assign_tag', to: 'tags#assign'
      get 'remove_tag_assignment', to: 'tags#remove_assignment'
      delete 'unassign_tag', to: 'tags#unassign'
    end

    resources :beverages, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
      post 'deactivate', on: :member
      post 'activate', on: :member
      resources :servings, only: [ :new, :create, :edit, :update ] do
        get 'history', to: 'servings#history'
      end
    end

    get '/menu_items_search', to: 'menu_search#index'

    resources :staff_members, only: [ :index, :new, :create ]

    resources :item_option_sets, only: [ :show, :new, :create ] do
      get 'new_dish', to: 'item_option_sets#new_dish'
      post 'add_dish', to: 'item_option_sets#add_dish'
      get 'new_beverage', to: 'item_option_sets#new_beverage'
      post 'add_beverage', to: 'item_option_sets#add_beverage'
      get 'remove_item', to: 'item_option_sets#remove_item'
      delete 'delete_item', to: 'item_option_sets#delete_item'
    end

    resources :discounts, only: [ :index, :new, :create, :show ] do
      get 'new_dish_serving', to: 'discounts#new_dish_serving'
      get 'new_beverage_serving', to: 'discounts#new_beverage_serving'
      post 'assign_serving', to: 'discounts#assign'
    end

    post 'order_add_item', to: 'orders#add_item'
    get 'new_order', to: 'orders#new'
    post 'orders', to: 'orders#create'
    get 'orders', to: 'orders#index'
    resources :orders, only: [ :show ]
  end

  get '/check_order', to: 'check_orders#check_order_form', as: 'check_order_form'
  get '/check_order/order', to: 'check_orders#show', as: 'check_order'

  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      get '/orders', to: 'orders#index'
      get '/order', to: 'orders#show'
      post '/order/prepare', to: 'orders#prepare'
      post '/order/mark_ready', to: 'orders#mark_ready'
      post '/order/deliver', to: 'orders#deliver'
      post '/order/cancel', to: 'orders#cancel'
    end
  end
end
