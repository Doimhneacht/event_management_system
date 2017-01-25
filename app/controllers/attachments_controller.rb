class AttachmentsController < ApplicationController
  # POST /api/events/:event_id/attachments
  def create
    return bad_request('No files to attach') if attachment_params.empty?
  end

  # DELETE /api/events/:event_id/attachments/:id
  def destroy

  end

  private

  def attachment_params
    params.require(:attachment).permit(:filename, :content_type, :file_contents)
  end

  def user_is_owner

  end
end
