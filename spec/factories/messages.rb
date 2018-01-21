FactoryBot.define do
  factory :message do
    sequence(:body) { |i| "message #{i}" }

    # trait :from_arenah do
      # TODO: Fix arenah message engine and change this file
      # from 0
    # end
  end
end
