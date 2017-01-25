class CommentsController < ApplicationController
  before_action :set_comment, except: [:create, :index]

  # GET /api/events/:event_id/comments
  def index
    return forbidden unless user_can_access_comments

    render json: Event.find_by_id(params[:event_id]).comments, status: :ok
  end

  # POST /api/events/:event_id/comments
  def create
    return forbidden unless user_can_access_comments

    comment = current_resource_owner.comments.build(full_params)

    return bad_request(comment.errors.full_messages) unless comment.save

    render json: {comment: comment}, status: :created
  end

  # PUT or PATCH /api/events/:event_id/comments/:id
  def update
    return forbidden unless user_owns_comment
    return bad_request(@comment.errors.full_messages) unless @comment.update_attributes(text: comment_params)

    render json: {message: 'The comment has been updated'}, status: :ok
  end

  # DELETE /api/events/:event_id/comments/:id
  def destroy
    return forbidden unless user_owns_comment

    @comment.destroy

    render json: {message: 'The comment has been deleted'}, status: :ok
  end

  private

  def comment_params
    params.permit(:text)
  end

  def full_params
    comment_params.merge(event_id: params[:event_id])
  end

  def user_can_access_comments
    current_resource_owner.events.include?(Event.find_by_id(params[:event_id]))
  end

  def user_owns_comment
    @comment.user_id == current_resource_owner.id
  end

  def set_comment
    @comment = Comment.find_by_id(params[:id])
  end
end
