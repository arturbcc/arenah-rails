module Legacy
  # `UserId`
  # `PartnerId`
  # `Signature`
  # `ShowSignature`
  # `PostCount`
  # `LastLogin`
  # `IsPartnerAdmin`
  # `CreationDate`
  # `NickName`
  # `AvatarUrl`
  # `ICQ`
  # `AIM`
  # `MSN`
  # `YM`
  # `LastUpdate`
  # `WebSite`
  # `TopicCount`
  # `Status`
  # `LastPostDateTime`
  # `PassportId`
  class LegacyUserPartner < Legacy::LegacyModel
    USER_PARTNER_ID = 0
    CREATED_AT = 7
    NAME = 8
    AVATAR_URL = 9
    STATUS = 17
    PASSPORT_ID = 19
    POST_COUNT = 4

    attr_reader :id, :user_id

    def self.build_from_row(row)
      LegacyUserPartner.new(
        id: row[USER_PARTNER_ID],
        user_id: row[PASSPORT_ID].to_i,
        name: row[NAME],
        avatar: row[AVATAR_URL],
        status: row[STATUS].to_i,
        created_at: Date.parse(row[CREATED_AT]),
        post_count: row[POST_COUNT].to_i
      )
    end

    def invalid?
      @name == 'qa'
    end

    def build_legacy_character
      Legacy::LegacyCharacter.new(
        user_id: @user_id,
        user_partner_id: @id,
        name: @name,
        avatar: @avatar, # I NEED TO COPY THE IMAGE TO THE NEW SERVER
        status: @status,
        character_type: 2, # game master
        created_at: @created_at,
        post_count: @post_count,
        gender: 0
      )
    end
  end
end
