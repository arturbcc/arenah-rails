FactoryGirl.define do
  factory :message do
    sequence(:body) { |i| "message #{i}" }

    trait :from_arenah do
      from 0
    end
  end
end
