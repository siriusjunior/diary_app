Rails.application.routes.draw do
  root 'diaries#index'
  # constraints -> request { request.session[:user_id].present? } do
  #   #ログイン時のルート
  #   root 'diaries#index'
  # end

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  resources :users do
    %i[new create]
    member do
      get :activate
    end
  end
  patch 'diary_reset', to: 'users#reset_diary_date'
  # patch '/diaries/:id', to: 'diaries#reset_diary_image', as: 'reset_image'
  resources :password_resets, only: %i[new create edit update]
  resources :diaries do
    member do
      patch :reset_image
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
