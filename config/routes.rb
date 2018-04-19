Rails.application.routes.draw do
  resources :contest_types, only: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
