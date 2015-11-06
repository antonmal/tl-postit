class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = User.first

    if @comment.save
      flash[:notice] = 'Comment saved successfully.'
      redirect_to @post
    else
      render 'posts/show'
    end
  end
end
