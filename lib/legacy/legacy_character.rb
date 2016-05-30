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
  class LegacyCharacter
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

    def self.build_from_row(row)
      LegacyCharacter.new(
        user_id: row[USER_ID],
        name: row[NAME],
        avatar: row[AVATAR], # I NEED TO COPY THE IMAGE TO THE NEW SERVER
        forum_id: row[FORUM_ID],
        status: row[STATUS].to_i,
        character_type: 1 - row[CHARACTER_TYPE].to_i,
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
    # There are a few attributes that are different, though:
    #
    # Status: the status is the inverse of the legacy status. While 0 was
    # active and 1 inactive, it is now the opposite: 0 is inactive and
    # 1 is active, because it makes more sense.
    def create!(user)
      status = 1 - self.status

      Character.create!(
        user: user,
        name: @name,
        avatar: 'inuyasha.jpg',
        post_count: @post_count,
        signature: @signature,
        last_post_date: Time.now,
        sheet: load_sheet('crossover', 'inuyasha'),
        status: 1 - @status
      )
    end
  end
end
