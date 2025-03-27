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
    # @user = @post.user　匿名投稿のために変更
    # 匿名投稿を許可するために、投稿に紐づいているユーザー情報を取得する処理を変更している
    @user = User.find_by(id: @post.user_id)


    # 共感数を取得するためのインスタンス変数を定義している
    @likes_count = Like.where(post_id: @post.id).count

    # 自作、インスタンスメソッドを使って、投稿に紐づいているカテゴリー情報を取得している。そのインスタンスメソッドはpost.rbに定義されている
    @category = @post.category

    #タグの情報を取得するためのインスタンス変数を定義している
    @tags = @post.tags

    # コメントの情報を取得するためのインスタンス変数を定義している
    @comments = @post.comments.includes(:user) # コメントを取得
    
  end

  # 新規の投稿をするためのアクション
  def new
     # newメソッドを用いて、Postクラスのインスタンスを作成している。つまり、postモデルの丸ごとの新しいインスタンスを作成している
     @post = Post.new
     @categories = Category.all

    render :new
  end


  def create
        # 今回は逆にHTMLから指定のURLに移動してフォームから送信されたデータを受け取り、保存する処理を行っている
        # ログイン中のユーザーのidは@current_userに代入されているので、ログイン中のユーザーのidをuser_idカラムに保存している
        @post = Post.new(content: params[:content], user_id: @current_user.id, category_id: params[:category_id], anonymous: params[:is_anonymous])

    # if @post.anonymous管理者は知る必要がありいらない
    #   @post.user_id = nil  # 匿名の場合、ユーザー情報を紐付けない
    # end

    # saveメソッドは保存出来たらtrue、出来なかったらfalseを返す。保存出来たら投稿一覧ページにリダイレクト、出来なかったら新規投稿ページにリダイレクト
    if @post.save
    # flash[:notice]はリダイレクト先で表示されるメッセージを設定するための変数でコントローラーからビューにデータを渡すためのメソッド
    flash[:notice] = "投稿を作成しました"
    # redirect_toメソッドを用いて、自動的に投稿一覧ページに転送されるようにしている
    redirect_to("/posts/index")
    else
      render("posts/new", status: :unprocessable_entity)
    end
    
    # 新規投稿のタグを保存する処理を追加する ビューで決めたtag_nameを取得して文字列をスペース区切りで配列に変換している
    tag_name = params[:tag_name].gsub("　", " ")
    # 配列に変換したtag_nameをスペース区切りで分割している。しかし、このままだと配列の要素が一つしかないので、split(nil)を使って、スペース区切りで分割している
    tag_list = tag_name.split(nil)
    # 配列の要素を一つずつ取り出して、それぞれの要素に対して処理を行う。配列がゼロの場合は処理を行わず、endで処理を終了する
    tag_list.each do |tag_name|
      # タグの中身が同じ場合、そのタグがすでに存在しているかどうかをチェックする処理をif文で追加する
      @tag = Tag.find_by(name: tag_name)
      # @tagがnilの場合、そのタグがまだ存在していないので、新しくタグを作成する処理を追加する
      if @tag.nil?
        # タグの中身を保存する処理を追加する
        @tag = Tag.new(name: tag_name)
        @tag.save
      end
        # タグとpostの中間テーブルに保存する処理を追加する
        # @post_tag = PostTag.new(post_id: @post.id, tag_id: @tag.id)
        # @post_tag.save
        # else
        # すでに存在しているタグの場合、そのタグとpostの中間テーブルに保存する処理を追加する
        # @post_tag = PostTag.new(post_id: @post.id, tag_id: @tag.id)
        # @post_tag.save
      
      # すでに存在しているタグの場合、そのタグとpostの中間テーブルに保存する処理を追加する
      @post_tag = PostTag.new(post_id: @post.id, tag_id: @tag.id)
      @post_tag.save
    end
  end

  # 編集ボタンを押すとshow.html.erbの埋め込みの変数にidが入る。そこにあるリンクに対応しているpostのeditアクションがここだとルーティングで決めている
  def edit
    @post = Post.find_by(id: params[:id])
    @categories = Category.all # カテゴリーの情報を取得
  end

  # 更新したら一覧に戻る
  def update
    # updateアクションのルーティングにあるURLにはidが含まれているのでこのparamsはURLからidを取得している
    @post = Post.find_by(id: params[:id])
    # もう一つのparamsパターンname属性に入力された編集後の内容が入る
    @post.content = params[:content]
    # カテゴリーの情報を更新
    @post.category_id = params[:category_id]
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



  # 検索用のアクション
  def search
    # パラメータからカテゴリー情報を取得して検索
    if params[:category].present?
      @posts = Post.where(category: params[:category])
    else
      @posts = Post.all
    end

    # キーワード検索 (投稿内容に含まれる単語を部分一致で検索)
    if params[:keyword].present?
      @posts = @posts.where('content LIKE ?', "%#{params[:keyword]}%")
    end

    render :index  # 検索結果は一覧ページに表示
  end


  # いいねしたユーザー一覧を表示するアクション
  def likeusers
    @post = Post.find_by(id: params[:id])
    @users = User.where(id: Like.where(post_id: @post.id).pluck(:user_id))

    render :likeusers
  end

  # タグ検索用のアクション
  def tagsearch
    @tag = Tag.find_by(name: params[:tag_name])
    # タグがない場合は、フラッシュで外套のデータがありませんと表示して、投稿一覧ページにリダイレクトする
    if @tag.nil?
      flash[:notice] = "そのデータは存在しません"
      redirect_to("/posts/index")
    else
      # タグの名前を取得して、そのタグに紐づいている投稿を取得している
      @posts = @tag.posts
      if @posts.empty?
        flash[:notice] = "そのデータは存在しません"
        redirect_to("/posts/index")
      else
        render :index
      end
    end
  end
  
end


