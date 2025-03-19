class CommentsController < ApplicationController
    before_action :authenticate_user
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        flash[:notice] = "コメントを投稿しました"
        redirect_to post_path(@post)
      else
        flash[:alert] = "コメントの投稿に失敗しました"
        redirect_to post_path(@post)
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
      redirect_to post_path(@comment.post)
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end