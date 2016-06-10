# frozen_string_literal: true

module Legacy
  module RpgSystem
    # `AccountId`
    # `Attribute1`
    # `Attribute2`
    # `Attribute3`
    # `Attribute4`
    # `Attribute5`
    # `Attribute6`
    # `Attribute7`
    # `Attribute8`
    # `Attribute9`
    # `Attribute10`
    # `Life`
    # `Mana`
    # `Level`
    # `XP`
    # `ShowSheet`
    # `TotalLife`
    # `TotalMana`
    # `TotalCash`
    # `Cash`
    # `LastInventoryUpdate`
    class LegacySheetData < LegacyModel
      ACCOUNT_ID = 0
      ATTRIBUTE1 = 1
      ATTRIBUTE2 = 2
      ATTRIBUTE3 = 3
      ATTRIBUTE4 = 4
      ATTRIBUTE5 = 5
      ATTRIBUTE6 = 6
      ATTRIBUTE7 = 7
      ATTRIBUTE8 = 8
      ATTRIBUTE9 = 9
      ATTRIBUTE10 = 10
      LIFE = 11
      MANA = 12
      LEVEL = 13
      XP = 14
      TOTAL_LIFE = 16
      TOTAL_MANA = 17
      TOTAL_CASH = 18
      CASH = 19

      attr_reader :user_account_id,
        :attribute1, :attribute2, :attribute3, :attribute4, :attribute5,
        :attribute6, :attribute7, :attribute8, :attribute9, :attribute10,
        :life, :total_life, :mana, :total_mana, :xp, :level, :cash

      def self.build_from_row(row)
        LegacySheetData.new(
          user_account_id: row[ACCOUNT_ID],
          attribute1: row[ATTRIBUTE1].to_i,
          attribute2: row[ATTRIBUTE2].to_i,
          attribute3: row[ATTRIBUTE3].to_i,
          attribute4: row[ATTRIBUTE4].to_i,
          attribute5: row[ATTRIBUTE5].to_i,
          attribute6: row[ATTRIBUTE6].to_i,
          attribute7: row[ATTRIBUTE7].to_i,
          attribute8: row[ATTRIBUTE8].to_i,
          attribute9: row[ATTRIBUTE9].to_i,
          attribute10: row[ATTRIBUTE10].to_i,
          life: row[LIFE].to_i,
          mana: row[MANA].to_i,
          level: row[LEVEL].to_i,
          cash: row[CASH].to_i,
          xp: row[XP].to_i,
          total_life: row[TOTAL_LIFE].to_i,
          total_mana: row[TOTAL_MANA].to_i,
          total_cash: row[TOTAL_CASH].to_i
        )
      end
    end
  end
end
