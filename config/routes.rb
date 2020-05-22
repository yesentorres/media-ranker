Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'works#main'

  resources :works

  resources :users, only: [:index, :show]

end
