Rails.application.routes.draw do
  devise_for :users
  root 'artists#index'
  resources :playlists
  resources :songs
  resources :albums
  resources :artists
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
