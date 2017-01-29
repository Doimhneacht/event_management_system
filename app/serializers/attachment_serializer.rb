class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :filename, :content_type, :file_contents
end
