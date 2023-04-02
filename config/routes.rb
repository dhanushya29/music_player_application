Rails.application.routes.draw do
  devise_for :artists do 
    root :to => "artists#index"
  end  
  devise_for :users 
  root 'homes#index'
  get :search,to: 'albums#search'
  resources :playlists do 
    post :insert,to: 'playlists#insert',on: :collection
  end 
  resources :songs
  resources :albums do
    post :insert , to: 'albums#insert' ,on: :collection
  end
  resources :users do 
    get :login,on: :collection
    get :profile,on: :collection
  end 
  resources :images
  resources :albums
  resources :artists do
    get :artist_albums,on: :member
    get :artist_page,on: :collection
    get :login,on: :collection
    get :artist_list,on: :collection
    get :artist_songs ,on: :member 
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
