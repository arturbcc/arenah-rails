FactoryBot.define do
  factory :topic do
    sequence(:title) { |i| "topic #{i}" }
    description 'topic description'
  end
end
