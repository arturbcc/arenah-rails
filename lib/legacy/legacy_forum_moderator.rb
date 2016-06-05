# frozen_string_literal: true

require 'legacy/legacy_model'
module Legacy
  # `ForumId`
  # `UserId`
  # `PartnerId`
  # `EditPost`
  # `EditTopic`
  # `DeletePost`
  # `ViewIpAddress`
  # `CreationDate`
  # `DeleteTopic`
  # `PassportId`
  # `AccessPanel`
  class LegacyForumModerator< Legacy::LegacyModel
    FORUM_ID = 0
    USER_ID = 1
    PASSPORT_ID = 9

    attr_reader :user_id, :passport_id, :forum_id

    def self.build_from_row(row)
      LegacyForumModerator.new(
        forum_id: row[FORUM_ID],
        user_id: row[USER_ID],
        passport_id: row[PASSPORT_ID].to_i
      )
    end
  end
end
