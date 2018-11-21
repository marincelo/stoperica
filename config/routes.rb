Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboard#info'
  get '/info' => 'dashboard#info'
end
