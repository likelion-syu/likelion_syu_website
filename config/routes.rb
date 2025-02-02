Rails.application.routes.draw do
  get 'search/result'

  devise_for :users, controllers: {registrations:'users/registrations'}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :posts
  resources :services
  resources :mains
  resources :users, only: [:show]
  
  # 홈페이지를 들어오자마자 먼저 로그인하도록 root를 설정
  root 'mains#index'
  get '/images' => 'images#new'
  get '/notice' => 'posts#notice'
  get '/homework' => 'posts#homework'
  get '/lecture' => 'posts#lecture'
  get '/freeboard' => 'posts#freeboard'
  get '/questions' => 'posts#questions'
  get '/photo' => 'posts#photo'
  get '/users/myposts' => 'posts#mypost'
  get '/users/list' => 'users#index'
  # ERROR
  get '/404', :to => 'errors#not_found'
  get '/422', :to => 'errors#unacceptable'
  get '/500', :to => 'errors#internal_error'
  get '/504', :to => 'errors#timeout_error'
  # tinymce
  post '/tinymce_assets' => 'tinymce_assets#create'
end
