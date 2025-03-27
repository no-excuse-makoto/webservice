class CommentsController < ApplicationController
  before_action :authenticate_user

  def create
    @post = Post.find(params[:post_id])
    reply_to_comment = Comment.find_by(id: params[:reply_to]) # 返信先のコメントを取得

    # コメント内容に返信先のユーザー名を追加
    if reply_to_comment
      reply_to_user_name = "@#{reply_to_comment.user.name}"
      content_with_reply = "#{reply_to_user_name} #{params[:content]}"
    else
      content_with_reply = params[:content]
    end

    @comment = @post.comments.build(
      content: content_with_reply,
      user_id: @current_user.id,
      reply_to: params[:reply_to]
    )

    if @comment.save
      flash[:notice] = "コメントを投稿しました"
      redirect_to "/posts/#{@post.id}"
    else
      flash[:alert] = "コメントの投稿に失敗しました"
      redirect_to "/posts/#{@post.id}"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == @current_user.id
      @comment.destroy
      flash[:notice] = "コメントを削除しました"
    else
      flash[:alert] = "コメントを削除する権限がありません"
    end
    redirect_to "/posts/#{@comment.post_id}"
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :reply_to)
  end
end