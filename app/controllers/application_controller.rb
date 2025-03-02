class ApplicationController < ActionController::Base
  # before_actionは、すべてのアクションが実行される前に実行されるメソッドを指定するためのメソッドです。
  before_action :set_current_user

  # 現在のユーザーを取得するメソッド
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # 同じクラスなので、@authenticat_userを使うことができる。このメソッドはログインしていない場合にログインページにリダイレクトするためのメソッドです。
  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end

  # ログインしている場合にログインページにアクセスした場合に投稿一覧ページにリダイレクトするためのメソッドです。
  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/posts/index")
    end
  end




  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
