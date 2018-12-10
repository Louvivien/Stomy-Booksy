Rails.application.routes.draw do
  devise_for :establishments
  devise_for :teachers
  devise_for :students

  root 'home#index'
  resources :students, only: [:show, :edit]
  resources :teachers, only: [:show, :edit] do
    resources :teacher_establishments, only: [:destroy]
    resources :teacher_cats, only: [:create, :destroy]
    resources :availability_slots, only: [:new, :create, :index]
  end
  resources :establishments, only: [:index, :show, :edit] do
    resources :teacher_establishments, only: [:create]
    get '/teachers/', to: 'establishments#index_of_teachers', as: :teachers_index
  end
  resources :resources, only: [:show, :create, :destroy, :edit] do
    resources :availability_slots, only: [:new, :create, :index]
    resources :teachers do
      resources :events, only: [:index, :create]
    end
  end
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'
  resources :events, only: [:show, :edit]
  resources :availability_slots, only: [:show, :edit, :update, :destroy]
end
