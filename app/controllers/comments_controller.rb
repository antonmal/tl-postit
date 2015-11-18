class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = 'Comment saved successfully.'
      redirect_to @post
    else
      render 'posts/show'
    end
  end

  def vote
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: Comment.find(params[:id]))

    if vote.valid?
      flash[:notice] = 'Your wote was counted.'
    else
      flash[:error] = 'You can only vote for this once.'
    end
    redirect_to :back
  end
end
