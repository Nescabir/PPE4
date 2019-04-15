Rails.application.routes.draw do
  get  'login' => 'pages#login'
  get  'home' => 'pages#home'

  root 'pages#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
