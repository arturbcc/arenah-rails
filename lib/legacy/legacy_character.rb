# frozen_string_literal: true

module Legacy
  # `UserAccountId`
  # `UserPartnerId`
  # `PartnerId`
  # `PassportId`
  # `Nickname`
  # `AvatarUrl`
  # `ForumId`
  # `Status`
  # `Type`
  # `CreationDate`
  # `LastUpdateDate`
  # `Signature`
  # `ShowSignature`
  # `TopicCount`
  # `PostCount`
  # `Gender`
  class LegacyCharacter < LegacyModel
    USER_ACCOUNT_ID = 0
    USER_PARTNER_ID = 1
    USER_ID = 3
    NAME = 4
    AVATAR = 5
    FORUM_ID = 6
    STATUS = 7
    CHARACTER_TYPE = 8
    CREATED_AT = 9
    SIGNATURE = 11
    POST_COUNT = 14
    GENDER = 15

    attr_reader :id, :user_id, :user_partner_id, :name, :arenah_character

    def self.build_from_row(row)
      LegacyCharacter.new(
        id: row[USER_ACCOUNT_ID],
        user_id: row[USER_ID].to_i,
        name: row[NAME],
        avatar: row[AVATAR], # I NEED TO COPY THE IMAGE TO THE NEW SERVER
        forum_id: row[FORUM_ID],
        status: row[STATUS].to_i,
        character_type: row[CHARACTER_TYPE].to_i,
        created_at: Date.parse(row[CREATED_AT]),
        signature: row[SIGNATURE],
        post_count: row[POST_COUNT].to_i,
        gender: row[GENDER].to_i
      )
    end

    def male?
      @gender == 0
    end

    def female?
      @gender == 1
    end

    def active?
      status = 0
    end

    # It creates a new character based on a legacy character.
    #
    # There are a few attributes issues to be known:
    #
    # * Status: prior to this migration, the status code followed these rules:
    #   - Active = 0,
    #   - Deleted = 1,
    #   - Closed = 2,
    #   - Blocked = 3
    #
    # From now on, 0 will be inactive and 1 is active, because it simply makes
    # more sense.
    #
    # * Name: the name of the character could be an empty string before. It
    # will not be valid anymore and those cases will use the name 'Sem nome'
    def create!(user)
      @arenah_character = Character.create!(
        user: user,
        name: @name.present? ? @name : 'Sem nome',
        avatar: @avatar,
        post_count: @post_count,
        signature: @signature,
        last_post_date: Time.now,
        sheet: '{}',
        status: @status == 0 ? 1 : 0,
        character_type: @character_type,
        created_at: @created_at
      )
    end
  end
end
