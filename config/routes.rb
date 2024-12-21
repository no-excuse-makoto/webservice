Rails.application.routes.draw do
  get "users/index" => "users#index"
  
  # 1 generate controllerで追加されたルーティング
  get "/" => "home#top"
  # aboutのURLを省略
  get "about" => "home#about"

  # 2 投稿するために作られた。右側は自分でわかるように追加
  get "posts/index" => "posts#index"

  # 4 新規投稿ページ
  get "posts/new" => "posts#new"

  # 3　投稿の詳細IDに対応している
  get "posts/:id" => "posts#show"

  # 5 投稿作成からデータベースを操作するアクション
  post "posts/create" => "posts#create"

  # 6 editアクションへのルーティングを追加
  get "posts/:id/edit" => "posts#edit"

  # 7 show.html.erbが受け取ったURLからupdateアクションにルーティングしている
  post "posts/:id/update" => "posts#update"

  # 8 削除を押したら、idのあるこのリンクに飛ばされてdestroyアクションに行く
  delete "posts/:id/destroy" => "posts#destroy"

  # 9 ユーザー詳細ページ
  get "users/:id" => "users#show"

  # 10 ユーザー新規登録ページ
  get "signup" => "users#new"

  # 11 ユーザー新規登録からデータベースを操作するアクション
  post "users/create" => "users#create"

  # 12 ユーザー編集ページ
  get "users/:id/edit" => "users#edit"

  # 13 ユーザー編集からデータベースを操作するアクション
  post "users/:id/update" => "users#update"

  # 14 ログインページへのルーティング
  get "login" => "users#login_form"

  # 15 ログインからデータベースを操作するアクション。ルーティングがpostなので、getとは違うルーティング
  post "login" => "users#login"

  # 16 ログアウトからsessionを削除するアクション
  delete "logout" => "users#logout"






  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
