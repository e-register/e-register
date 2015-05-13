Rails.application.routes.draw do

  # UsersController
  get '/user' => 'users#show', as: 'current_user'
  get '/user/edit' => 'users#edit', as: 'edit_current_user'
  resources :users, path: 'user', except: :index

  # KlassesController
  resources :klasses, path: 'classes'

  # EvaluationsController
  get '/evaluations/teacher/:teacher_id' => 'evaluations#teacher', as: 'evaluations_teacher'
  get '/evaluations/student/:student_id' => 'evaluations#student', as: 'evaluations_student'
  get '/evaluations/teacher/:teacher_id/new' => 'evaluations#new', as: 'new_evaluation_teacher'
  get '/evaluations/teacher/:teacher_id/new_class' => 'evaluations#new_klass', as: 'new_evaluation_teacher_klass'
  post '/evaluations/teacher/:teacher_id/new_class' => 'evaluations#create_klass', as: 'create_evaluation_teacher_klass'
  resources :evaluations, except: :new

  # Authentication
  devise_for :users

  # Home Page
  root 'application#home'
end
