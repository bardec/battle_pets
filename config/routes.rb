Rails.application.routes.draw do
  resources :contest_types, only: :index
  resources :contests, only: [:create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
