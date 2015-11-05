PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  # get 'posts', to: 'posts#index'
  # get 'posts/:id', to: 'posts#show', as: 'post'
  # get 'posts/new', to: 'posts#new'
  # post 'posts', to: 'posts#create'
  # get 'posts/:id/edit', to: 'posts#edit'
  # patch 'posts/:id', to: 'posts#update'
  # put 'posts/:id', to: 'posts#update'
  # destroy 'posts/:id', to: 'posts#destroy'

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create, :show]
  end

  resources :categories
end
