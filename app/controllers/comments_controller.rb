class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_commentable

  respond_to :js

  def create
    @comment = @commentable.comments.create( comment_params.merge( user: current_user ))
    respond_with @comment
  end

  private

  def set_commentable
    @commentable = commentable_name.classify
    .constantize.find(params["#{commentable_name.singularize}_id".to_sym])
  end

  def commentable_name
    params[:commentable]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
