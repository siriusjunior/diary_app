Rails.application.routes.draw do
  root 'diaries#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'user_sessions/store_location'
  
  resources :users, only: %i[index new create show] do
    member do
      get :activate
      get :diaries
      get :following, :followers
    end
    collection do
      get 'search'
    end
  end
  #ユーザーにタグを追加・削除する
  post "users/:id/tag" => "users#add_tag"
  delete "users/:id/tag" => "users#remove_tag"
  #tagsリソースにネストされたusersリソースを定義、タグで絞込みuser表示
  resources :tags do
    resources :users, only: [:index]
  end

  resources :tags, only: %i[index], on: :collection, defaults: { format: 'json' } 

  patch 'diary_reset', to: 'users#reset_diary_date'
  resources :password_resets, only: %i[new create edit update]
  resources :diaries, shallow: true  do
    collection do
      get :search
    end
    # collection do
    #   get :order
    # end
    resources :comments
    member do
      patch :reset_image
    end
  end
  resources :likes, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :activities, only: [] do
    patch :read, on: :member
  end

  resources :chatrooms, only: %i[index create show], shallow: true do
    resources :messages
  end

  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
    resource :notification_setting, only: %i[edit update]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
