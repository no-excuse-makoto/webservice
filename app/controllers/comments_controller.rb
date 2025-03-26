class CommentsController < ApplicationController
    before_action :authenticate_user
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(content: params[:content], user_id: @current_user.id)
  
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
      if @comment.user == current_user
        @comment.destroy
        flash[:notice] = "コメントを削除しました"
      else
        flash[:alert] = "コメントを削除する権限がありません"
      end
      redirect_to "/posts/#{@post.id}/destroy"
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end