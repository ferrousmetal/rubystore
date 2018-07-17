Rails.application.routes.draw do
  # root 'products#index'
  devise_for :users

  namespace :admin do
    resources :orders do
      member do
        post :cancel
        post :ship
        post :shipped
        post :return
      end
    end
    resources :products
  end

  resources :products do
    collection do
      get :search
    end

    member do
      post :add_to_cart
    end
  end

  resources :carts do
    collection do
      delete :clean
      post :checkout
    end
  end

  resources :cart_items

  resources :orders do
    member do
      post :pay_with_alipay
      post :pay_with_wechat
      post :apply_to_cancel
    end
  end

  namespace :account do
    resources :orders
  end

  get '/welcome' => 'welcome#index'
  root 'welcome#index'
end
