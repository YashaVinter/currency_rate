Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  namespace :api do
    namespace :v1 do
      get 'rate/index'
      post 'rate/create'
      get 'rate/admin_rates'
    end
  end
  root "homepage#index"
  get '/*path' => 'homepage#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
