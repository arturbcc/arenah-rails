# frozen_string_literal: true

require 'legacy/legacy_model'
module Legacy
  # `PostId`
  # `PartnerId`
  # `TopicId`
  # `AuthorId`
  # `Subject`
  # `Text`
  # `Status`
  # `IPAddress`
  # `CreationDate`
  # `IsFirstPostFromTopic`
  # `AuthorName`
  # `PassportId`
  # `UserAccountId`
  class LegacyPost < Legacy::LegacyModel
    POST_ID = 0
    TOPIC_ID = 2
    AUTHOR_ID = 3
    TEXT = 5
    STATUS = 6
    CREATED_AT = 8
    AUTHOR_NAME = 10
    USER_ID = 11

    attr_reader :topic_id, :author_id, :id, :author_name

    def self.build_from_row(row)
      LegacyPost.new(
        id: row[POST_ID],
        topic_id: row[TOPIC_ID],
        author_id: row[AUTHOR_ID],
        text: row[TEXT],
        # Active = 0,
        # Pending = 1,
        # Deleted = 2
        status: row[STATUS].to_i,
        user_id: row[USER_ID].to_i,
        author_name: row[AUTHOR_NAME]
      )
    end

    def active?
      @status == 0
    end

    def create!(topic, character)
      return unless @text.present?

      post = Post.create!(
        topic: topic,
        character: character,
        message: @text,
        recipients: []
      )
    end
  end
end
