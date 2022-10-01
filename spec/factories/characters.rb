FactoryBot.define do
  factory :character do
    sequence(:name) { |i| "character #{i}" }
    character_type { 0 }

    trait :npc do
      character_type { 1 }
    end

    trait :game_master do
      character_type { 2 }
    end

    trait :female do
      gender { 1 }
    end
  end
end
