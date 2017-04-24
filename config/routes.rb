Rails.application.routes.draw do
  resources :information
  get 'home/index'
  root to: 'information#new'
end
