FactoryBot.define do
  factory :topic_group do
    # game_id 1
    position 1
    sequence(:name) { |i| "group #{i}" }
  end
end
