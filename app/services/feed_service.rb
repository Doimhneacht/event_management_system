class FeedService

  def initialize(event)
    @comments = event.comments
    @attachments = event.attachments
  end

  def generate_feed_json
    list = generate_list_of_changes
    list.sort! { |a, b| b[:updated_at] <=> a[:updated_at] }

    list.map! do |change|
      {
          id: change[:id],
          type: type_of(change),
          attributes: generate_attributes(change)
      }
    end

    list
  end

  private

  def standardize(object)
    { id: object.id,
      class: object.class,
      updated_at: object.updated_at }
  end

  def type_of(object)
    object[:class].to_s.downcase.pluralize
  end

  def generate_list_of_changes
    standardized_comments = @comments.map do |comment|
      standardize(comment)
    end
    standardized_attachments = @attachments.map do |attachment|
      standardize(attachment)
    end

    standardized_comments + standardized_attachments
  end

  def generate_attributes(object)
    hash = object[:class].find(object[:id]).as_json
    hash.delete('id')
    hash
  end

end