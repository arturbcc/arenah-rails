FactoryGirl.define do
  factory :game do
    name 'Resident Evil'
    status 1

    trait :closed do
      status 0
    end
  end
end