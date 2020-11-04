Rails.application.routes.draw do
  root "homes#top"
  get 'home/about' => 'homes#about', as: 'about'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show,:index,:edit,:update] 
  
  resources :users do
    member do
     get :following, :followers
    end
  end
  resources :relationships,       only: [:create, :destroy]
  
 
  resources :books do
     resource :favorites, only: [:create, :destroy]
     resources :book_comments, only: [:create, :destroy]
  end

end