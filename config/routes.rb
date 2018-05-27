Rails.application.routes.draw do
  resources :start_numbers
  devise_for :users
  authenticated do
    root :to => 'dashboard#index', as: :authenticated
  end
  root to: 'dashboard#info'

  get '/timing' => 'dashboard#timing'
  get '/live' => 'dashboard#live'
  post '/timesync' => 'dashboard#timesync'
  get '/info' => 'dashboard#info'

  resources :clubs
  resources :categories
  resources :race_results do
    collection do
      match :from_device, via: [:get, :post]
      post :from_timing
      delete :destroy_from_timing
    end
  end
  resources :races do
    collection do
      get :get_live
    end
  end
  resources :racers do
    collection do
      get :login, to: 'racers#login_form'
      post :login
    end
  end
end
