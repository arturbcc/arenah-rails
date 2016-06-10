# frozen_string_literal: true

module Legacy
  module RpgSystem
    # `ForumId`
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
    # `ModelSheet`
    # `Abbreviation1`
    # `Abbreviation2`
    # `Abbreviation3`
    # `Abbreviation4`
    # `Abbreviation5`
    # `Abbreviation6`
    # `Abbreviation7`
    # `Abbreviation8`
    # `Abbreviation9`
    # `Abbreviation10`
    class LegacySheetAttributes < LegacyModel
      FORUM_ID = 0
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
      ABBREVIATION1 = 12
      ABBREVIATION2 = 13
      ABBREVIATION3 = 14
      ABBREVIATION4 = 15
      ABBREVIATION5 = 16
      ABBREVIATION6 = 17
      ABBREVIATION7 = 18
      ABBREVIATION8 = 19
      ABBREVIATION9 = 20
      ABBREVIATION10 = 21

      attr_reader :forum_id, :attribute1, :attribute2, :attribute3,
      :attribute4, :attribute5, :attribute6, :attribute7, :attribute8,
      :attribute9, :attribute10, :abbreviation1, :abbreviation2, :abbreviation3,
      :abbreviation4, :abbreviation5, :abbreviation6, :abbreviation7, :abbreviation8,
      :abbreviation9, :abbreviation10

      def self.build_from_row(row)
        LegacySheetAttributes.new(
          forum_id: row[FORUM_ID],
          attribute1: row[ATTRIBUTE1],
          attribute2: row[ATTRIBUTE2],
          attribute3: row[ATTRIBUTE3],
          attribute4: row[ATTRIBUTE4],
          attribute5: row[ATTRIBUTE5],
          attribute6: row[ATTRIBUTE6],
          attribute7: row[ATTRIBUTE7],
          attribute8: row[ATTRIBUTE8],
          attribute9: row[ATTRIBUTE9],
          attribute10: row[ATTRIBUTE10],
          abbreviation1: row[ABBREVIATION1].to_i,
          abbreviation2: row[ABBREVIATION2].to_i,
          abbreviation3: row[ABBREVIATION3].to_i,
          abbreviation4: row[ABBREVIATION4].to_i,
          abbreviation5: row[ABBREVIATION5].to_i,
          abbreviation6: row[ABBREVIATION6].to_i,
          abbreviation7: row[ABBREVIATION7].to_i,
          abbreviation8: row[ABBREVIATION8].to_i,
          abbreviation9: row[ABBREVIATION9].to_i,
          abbreviation10: row[ABBREVIATION10].to_i
        )
      end

      def [](key)
        self.public_send(key)
      end
    end
  end
end
