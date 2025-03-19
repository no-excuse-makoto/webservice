class UsersController < ApplicationController
  # application_controller.rbで定義したメソッドを使うためにbefore_actionを使っているが、index,show,edit,updateアクションのみログインしていないと見れないようにする
  before_action :authenticate_user, { only: [ :index, :show, :edit, :update ] }
  # application_controller.rbで定義した。ここではすでにログインしている場合にログインページにアクセスした場合に投稿一覧ページにリダイレクトするためのメソッドを使っている
  before_action :forbid_login_user, { only: [ :new, :create, :login_form, :login ] }
  # ログイン中のユーザーのidは@current_user.idに、編集したいユーザーのidはparams[:id]にそれぞれ代入されている。
  before_action :ensure_correct_user, { only: [ :edit, :update ] }




  def index
    @users = User.all
  end

  # 投稿の詳細ページを表示するアクション
  def show
    @user = User.find_by(id: params[:id])
  end

  # 新規登録ページを表示するアクション
  def new
    @user = User.new
  end

  # 新規登録を行うアクション
  def create
    @user = User.new(name: params[:name],
    email: params[:email],
    password: params[:password])
    @user.image_name = "default_image.jpg"

    # ユーザー登録が成功した場合,ユーザー詳細ページにリダイレクトする
    if @user.save
      # ユーザー登録が成功した場合、セッションにユーザーIDを保存し、ユーザー詳細ページにリダイレクトする
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new", status: :unprocessable_entity)
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  # ユーザー情報を編集するアクション
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]

    # 画像が送信されている場合、public/user_imagesに保存する
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit", status: :unprocessable_entity)
    end
  end

  # ログインページを表示するアクション
  def login_form
  end

  # ログインを行うアクション
  def login
     # 入力内容と一致するユーザーを取得し、変数@userに代入
     @user = User.find_by(email: params[:email])
     # if文で@userが存在し、authenticateメソッドでハッシュ化されたパスワードが一致するかどうかを確認
     if @user && @user.authenticate(params[:password])
       # ログインに成功した場合、セッションにユーザーIDを保存し、投稿一覧ページにリダイレクトする
       session[:user_id] = @user.id
       flash[:notice] = "ログインしました"
       redirect_to("/posts/index")
     else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      # ログインに失敗した場合、入力した値を初期値にするためビューに渡す値を変数に入れて再度ログインページを表示する準備をする
      @email = params[:email]
      @password = params[:password]
       render("users/login_form", status: :unprocessable_entity)
     end
  end



  # ログアウトを行うアクション
  def logout
    # セッションに保存されているユーザーIDを削除し、ログアウトする
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def likes
    # ユーザー情報を取得
    @user = User.find_by(id: params[:id])
    # ユーザーが共感した投稿を取得
    @likes = Like.where(user_id: @user.id)
  end


  # 「ログイン中のユーザー」と「編集しようとしているユーザー」が正しいかどうかを確かめるためのメソッドを定義。to_iメソッドを使って、文字列を整数に変換している
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end


  # フォローするアクション
  def follow
    @user = User.find(params[:id])
    unless current_user.following?(@user)
      current_user.follow(@user)
      flash[:notice] = "#{@user.name}をフォローしました"
    end
    redirect_to user_path(@user)
  end

  # フォロー解除するアクション
  def unfollow
    @user = User.find(params[:id])
    if current_user.following?(@user)
      current_user.unfollow(@user)
      flash[:notice] = "#{@user.name}のフォローを解除しました"
    end
    redirect_to user_path(@user)
  end

  # フォロー一覧
  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

end
