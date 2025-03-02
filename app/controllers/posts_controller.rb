class PostsController < ApplicationController
  # application_controller.rbで定義したメソッドを使うためにbefore_actionを使っている
  before_action :authenticate_user

  # ログイン中のユーザーのidは@current_userに代入されているので、ログイン中のユーザーのidをuser_idカラムに保存している
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    # ビューに書くこともできるが定石に倣いアクション内に投稿の変数を定義,直接記入からモデルからのデータの取得に変更
    @posts = Post.all.order(created_at: :desc)
  end

  # 投稿詳細のビューに渡すためのアクションでここはpostコントローラーだからpost/:idを取得できる。だからidカラムの値がparams[:id]と等しい投稿をデータベースから取得して代入
  def show
    @post = Post.find_by(id: params[:id])
    # インスタンスメソッドを使って、投稿に紐づいているユーザー情報を取得している。そのインスタンスメソッドはpost.rbに定義されている
    @user = @post.user
    # 共感数を取得するためのインスタンス変数を定義している
    @likes_count = Like.where(post_id: @post.id).count
  end

  # 新規の投稿をするためのアクション
  def new
     # newメソッドを用いて、Postクラスのインスタンスを作成している。つまり、postモデルの丸ごとの新しいインスタンスを作成している
     @post = Post.new
  end


  def create
        # 今回は逆にHTMLから指定のURLに移動してフォームから送信されたデータを受け取り、保存する処理を行っている
        # ログイン中のユーザーのidは@current_userに代入されているので、ログイン中のユーザーのidをuser_idカラムに保存している
        @post = Post.new(content: params[:content], user_id: @current_user.id)

    # saveメソッドは保存出来たらtrue、出来なかったらfalseを返す。保存出来たら投稿一覧ページにリダイレクト、出来なかったら新規投稿ページにリダイレクト
    if @post.save
    # flash[:notice]はリダイレクト先で表示されるメッセージを設定するための変数でコントローラーからビューにデータを渡すためのメソッド
    flash[:notice] = "投稿を作成しました"
    # redirect_toメソッドを用いて、自動的に投稿一覧ページに転送されるようにしている
    redirect_to("/posts/index")
    else
      render("posts/new", status: :unprocessable_entity)
    end
  end

  # 編集ボタンを押すとshow.html.erbの埋め込みの変数にidが入る。そこにあるリンクに対応しているpostのeditアクションがここだとルーティングで決めている
  def edit
    @post = Post.find_by(id: params[:id])
  end

  # 更新したら一覧に戻る
  def update
    # updateアクションのルーティングにあるURLにはidが含まれているのでこのparamsはURLからidを取得している
    @post = Post.find_by(id: params[:id])
    # もう一つのparamsパターンname属性に入力された編集後の内容が入る
    @post.content = params[:content]
    # saveメソッドは保存出来たらtrue、出来なかったらfalseを返す。保存出来たら投稿一覧ページにリダイレクト、出来なかったら編集ページにリダイレクト
    if @post.save
      # flash[:notice]はリダイレクト先で表示されるメッセージを設定するための変数でコントローラーからビューにデータを渡すためのメソッド
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      # renderメソッドは指定したビューを表示するメソッドだから、ここではedit.html.erbを表示している。editアクションと同じビューを表示することで、編集画面に戻ることができる。status: :unprocessable_entityはHTTPステータスコードの一つで、処理ができなかったことを示す
      render("posts/edit", status: :unprocessable_entity)
    end
  end


  def destroy
    # paramsでURLのidを使ってデータを取得、そして削除
    @post = Post.find_by(id: params[:id])
    @post.destroy
    # flash[:notice]はリダイレクト先で表示されるメッセージを設定するための変数でコントローラーからビューにデータを渡すためのメソッド
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  # ログインしているユーザーが投稿を編集しようとした場合に、その投稿がログインしているユーザーのものかどうかをチェックするためのメソッド
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end
