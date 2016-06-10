# frozen_string_literal: true

module Legacy
  module RpgSystem
    # `AccountId`
    # `Sheet`
    class LegacyCharacterSheet < LegacyModel
      USER_ACCOUNT_ID = 0
      SHEET = 1

      attr_reader :user_account_id, :sheet

      def self.build_from_row(row)
        LegacyCharacterSheet.new(
          user_account_id: row[USER_ACCOUNT_ID],
          sheet: row[SHEET]
        )
      end
    end
  end
end
