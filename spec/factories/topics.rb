FactoryGirl.define do
  factory :topic do
    game_id 1
    character_id 1
    sequence(:title) { |i| "topic #{i}" }
    description 'topic description'
  end
end