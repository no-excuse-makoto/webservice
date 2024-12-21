class LikesController < ApplicationController
    # before_actionでログインしているかどうかを確認するメソッドを呼び出してください
    before_action :authenticate_user
    
    # createアクションを追加してください
    def create
    # 変数@likeを定義することで、Likeモデルの新しいインスタンスを作成してください
    @like = Like.new(user_id: @current_user.id, post_id: params[:post_id])
    @like.save
    # redirect_toメソッドを用いて、投稿詳細ページにリダイレクトしてください
    redirect_to("/posts/#{params[:post_id]}")
    end

    # 共感を削除するためdestroyメソッドを使って@likeに入っているLikeモデルのインスタンスを削除してください
    def destroy
        @like = Like.find_by(user_id: @current_user.id, post_id: params[:post_id])
        @like.destroy
        redirect_to("/posts/#{params[:post_id]}")
    end
    
  end
  