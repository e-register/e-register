Rails.application.routes.draw do

  # UsersController
  get '/user' => 'users#show', as: 'current_user'
  get '/user/edit' => 'users#edit', as: 'current_user_edit'
  resources :users, path: 'user', except: :index

  resources :klasses, path: 'classes'

  # Authentication
  devise_for :users

  # Home Page
  root 'application#home'
end
