module Legacy
  # `ForumId`
  # `PartnerId`
  # `CategoryId`
  # `AuthorId`
  # `LastPostId`
  # `Title`
  # `Description`
  # `TopicCount`
  # `PostCount`
  # `AuthorName`
  # `Status`
  # `DisplayOrder`
  # `AnonymousPosts`
  # `IPAddress`
  # `CreationDate`
  # `UrlTitle`
  # `LastUpdateDate`
  # `LastUpdateIpAddress`
  # `IsTopicModerated`
  # `IsPostModerated`
  # `PassportId`
  # `ParentForumId`
  # `IsGameRoom`
  # `GameSystemId`
  # `BannerUrl`
  # `PlayersAllowed`
  # `CurrentPlayers`
  # `PlayersCanEditSheet`
  class LegacyGame < Legacy::LegacyModel
    FORUM_ID = 0
    AUTHOR_ID = 3 # Character => Guid.
    TITLE = 5
    DESCRIPTION = 6
    STATUS = 10
    DISPLAY_ORDER = 11
    CREATED_AT = 14
    USER_ID = 20
    PARENT_FORUM_ID = 21
    GAME_SYSTEM_ID = 23
    IS_GAME_ROOM = 22
    BANNER_URL = 24

    attr_reader :user_id, :author_id, :title, :parent_forum_id, :arenah_game

    def self.build_from_row(row)
      LegacyGame.new(
        forum_id: row[FORUM_ID],
        author_id: row[AUTHOR_ID],
        title: row[TITLE],
        description: row[DESCRIPTION],
        status: row[STATUS].to_i,
        display_order: row[DISPLAY_ORDER].to_i,
        created_at: Date.parse(row[CREATED_AT]),
        user_id: row[USER_ID].to_i,
        parent_forum_id: row[PARENT_FORUM_ID],
        game_system_id: row[GAME_SYSTEM_ID],
        banner_url: row[BANNER_URL], # I NEED TO COPY THE IMAGE TO THE NEW SERVER
        is_game_room: row[IS_GAME_ROOM].to_i
      )
    end

    def name
      @title
    end

    def id
      @forum_id
    end

    def root?
      @parent_forum_id == '00000000-0000-0000-0000-000000000000'
    end

    def game_room?
      @is_game_room == 1
    end

    def active?
      @status == 0
    end

    # It creates a new game based on a legacy forum.
    #
    # There are a few attributes issues to be known:
    #
    # * Status: prior to this migration, the status code followed these rules:
    #   - Active = 0,
    #   - Deleted = 1,
    #   - Museum = 2,
    #   - Vip = 3
    #
    # From now on, 0 will be inactive and 1 is active, because it simply makes
    # more sense.
    def create!(character)
      @arenah_game = Game.create!(
        name: @title,
        status: @status == 0 ? 1 : 0,
        character: character,
        short_description: '', # crop from the legacy description?
        description: @description,
        banner: @banner_url,
        subtitle: '',
        system: '{}',
        created_at: @created_at
      )
    end
  end
end
