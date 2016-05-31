require 'legacy/legacy_model'

module Legacy
  # 0 `UserId`,
  # 1 `FullName`,
  # 2 `Birth`,
  # 3 `CityId`,
  # 4 `SecretQuestion`,
  # 5 `SecretAnswer`,
  # 6 `Password`,
  # 7 `Status`,
  # 8 `ActivationCode`,
  # 9 `RoleId`,
  # 10 `Login`,
  # 11 `NickName`,
  # 12 `CountryId`,
  # 13 `Sex`,
  # 14 `ShowEmailAddress`,
  # 15 `Avatar`,
  # 16 `Url`,
  # 17 `CreationDate`,
  # 18 `IsSuperAdmin`,
  # 19 `LastLoginDate`,
  # 20 `Quotation`,
  # 21 `ProfilePageView`,
  # 22 `BeforeLastLoginDate`,
  # 23 `InvitedByUserId`
  class LegacyUser < LegacyModel
    ID = 0
    NAME = 1
    BIRTH_DATE = 2
    PASSWORD = 6
    STATUS = 7
    EMAIL = 10
    CREATED_AT = 17

    attr_reader :id, :name, :email, :arenah_user

    def active?
      @status
    end

    def invalid?
      !active? || @name == 'qa'
    end

    def self.build_from_row(row)
      LegacyUser.new(
        id: row[ID].to_i,
        name: row[NAME],
        password: row[PASSWORD],
        status: row[STATUS] == 'A',
        email: row[EMAIL],
        created_at: Date.parse(row[CREATED_AT])
      )
    end

    def create!
      @arenah_user = User.create!(
        email: @email,
        name: @name,
        password: generate_password,
        legacy_password: @password,
        confirmed_at: @created_at,
        created_at: @created_at,
        active: @active
      )
    end

    private

    def generate_password
      SecureRandom.uuid[0..7]
    end
  end
end
