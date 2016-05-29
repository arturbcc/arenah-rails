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
    GENDER = 15

    def initialize(user_id:, name:, avatar:, forum_id:, status:, character_type:, created_at:, gender:)
      @user_id = user_id
      @name =  name
      @avatar = avatar
      @forum_id = forum_id
      @status = status
      @character_type = character_type
      @created_at = created_at
      @gender = gender
    end

    def self.build_from_row(row)
      LegacyCharacter.new(
        user_id: row[USER_ID],
        name: row[NAME],
        avatar: row[AVATAR], # I NEED TO COPY THE IMAGE TO THE NEW SERVER
        forum_id: row[FORUM_ID],
        status: row[STATUS] == 'A', # MAP THE VALID STATUSES
        character_type: row[CHARACTER_TYPE], # MAP THE VALID TYPES
        created_at: Date.parse(row[CREATED_AT]),
        gender: row[GENDER] # MAP THE VALID GENDERS
      )
    end
  end
end
