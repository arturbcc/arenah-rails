# frozen_string_literal: true

require 'legacy/legacy_model'
module Legacy
  # `TopicId`
  # `PartnerId`
  # `ForumId`
  # `AuthorId`
  # `LastPostId`
  # `Subject`
  # `PostCount`
  # `PageViews`
  # `AuthorName`
  # `Status`
  # `IsFixed`
  # `AnonymousPosts`
  # `IPAddress`
  # `CreationDate`
  # `UrlTitle`
  # `PassportId`
  # `UserAccountId`
  # `TopicType`
  # `IsPublic`
  class LegacyTopic < Legacy::LegacyModel
    TOPIC_ID = 0
    FORUM_ID = 2
    AUTHOR_ID = 3
    TITLE = 5
    AUTHOR_NAME = 8
    STATUS = 9
    CREATED_AT = 13

    # Common = 0,
    # Subscription = 1,
    # AboutTheGame = 2,
    # Game = 3
    TOPIC_TYPE = 17

    attr_reader :arenah_topic, :forum_id, :id, :author_name, :author_id

    attr_accessor :forum

    def self.build_from_row(row)
      LegacyTopic.new(
        id: row[TOPIC_ID],
        title: row[TITLE],
        author_id: row[AUTHOR_ID],
        forum_id: row[FORUM_ID],
        status: row[STATUS].to_i,
        created_at: Date.parse(row[CREATED_AT]),
        topic_type: row[TOPIC_TYPE].to_i,
        author_name: row[AUTHOR_NAME]
      )
    end

    def name
      @title
    end

    def create!(game, topic_group, character, position)
      @arenah_topic = Topic.create!(
        title: @title.try(:strip) ||'Sem título',
        description: '',
        topic_group: topic_group,
        game: game,
        character_id: character.id,
        position: position
      )
    end
  end
end
