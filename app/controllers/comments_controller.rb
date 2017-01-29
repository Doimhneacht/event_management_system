class CommentsController < ApplicationController
  before_action :set_comment, except: [:create, :index]
  before_action :check_if_resources_exist, except: [:create, :index]

  # GET /api/events/:event_id/comments
  def index
    return forbidden unless user_can_access_comments

    render json: Event.find_by_id(params[:event_id]).comments, status: :ok
  end

  # POST /api/events/:event_id/comments
  def create
    return forbidden unless user_can_access_comments

    comment = current_resource_owner.comments.build(comment_params)
    comment.event_id = params[:event_id]

    return bad_request(comment.errors.full_messages) unless comment.save

    render json: comment, status: :created
  end

  # PUT or PATCH /api/events/:event_id/comments/:id
  def update
    return forbidden unless user_owns_comment
    return bad_request(@comment.errors.full_messages) unless @comment.update_attributes(text: comment_params[:text])

    render json: {data: {message: 'The comment has been updated'}}, status: :ok
  end

  # DELETE /api/events/:event_id/comments/:id
  def destroy
    return forbidden unless user_owns_comment

    @comment.destroy

    render json: {data: {message: 'The comment has been deleted'}}, status: :ok
  end

  private

  def comment_params
    params.permit(:text)
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

  def check_if_resources_exist
    return not_found('event') unless Event.find_by_id(params[:event_id])
    not_found('comment') unless @comment
  end
end
