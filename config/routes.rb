Rails.application.routes.draw do
  devise_for :users 
  root 'homes#index'
  resources :playlists
  resources :songs
  resources :albums do
    post :insert , to: 'albums#insert' ,on: :collection
  end
  resources :users do 
    resources :playlists
  end 
  resources :albums
  resources :artists do
    resources :albums
    get :artist_songs ,on: :member 
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
