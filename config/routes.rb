Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboard#index'

  get '/racers/login' => 'racers#login_form'
  post '/racers/login' => 'racers#login'

  resources :race_results
  resources :races
  resources :racers

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
