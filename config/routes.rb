Rails.application.routes.draw do
  use_doorkeeper do 
    skip_controllers :authorizations,:applications,:authorized_applications
  end
   devise_for :artists, controllers: {
        registrations: 'artists/registrations'
      }
    devise_for :users, controllers: {
        registrations: 'users/registrations'
      }
  namespace :api do
    namespace :v1 do
      resources :artists 

      resources :albums do 
        get '/total' => 'artists#total',on: :collection
      end 
      resources :users

      resources :songs,only: [:index,:new,:show,:create,:edit,:update,:destroy]

      resources :playlists do 
        get '/insert' => 'playlists#insert',on: :collection
      end

       resources :images
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  
  root 'homes#index'
  get :search,to: 'albums#search'
  resources :playlists do 
    post :insert,to: 'playlists#insert',on: :collection
    post :insertalbum,to: 'playlists#insertalbum',on: :collection
  end 
  resources :songs
  resources :albums do
    resources :images,module: :albums
      post :insert , to: 'albums#insert' ,on: :member
  end
  resources :users do 
    resources :images,module: :users
    get :login,on: :collection
    get :profile,on: :collection
  end 
  resources :images
  resources :albums 
  resources :artists do
    resources :images,module: :artists
    get :artist_albums,on: :member
    get :artist_page,on: :collection
    get :login,on: :collection
    get :artist_list,on: :collection
    get :artist_songs ,on: :member 
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
