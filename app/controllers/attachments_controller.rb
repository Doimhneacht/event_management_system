class AttachmentsController < ApplicationController
  before_action :check_if_resources_exist
  before_action :check_if_user_owns_event

  # POST /api/events/:event_id/attachments
  def create
    return bad_request('No files to attach') if attachment_params.empty?

    attachment = current_resource_owner.attachments.build(attachment_params)
    attachment.event_id = params[:event_id]

    return bad_request(attachment.errors.full_messages) unless attachment.save

    render json: {message: 'File has been saved'}, status: :created
  end

  # DELETE /api/events/:event_id/attachments/:id
  def destroy
    Attachment.find(params[:id]).destroy

    render json: {message: 'File has been deleted'}, status: :ok
  end

  private

  def attachment_params
    params.require(:attachment).permit(:filename, :content_type, :file_contents)
  end

  def user_is_owner
    Event.find(params[:event_id]).owner == doorkeeper_token.resource_owner_id
  end

  def check_if_user_owns_event
    forbidden unless user_is_owner
  end

  def check_if_resources_exist
    unless Event.find_by_id(params[:event_id]) && Attachment.find_by_id(params[:id])
      render json: {error: 'No such event or attachment'}, status: :not_found
    end
  end
end
