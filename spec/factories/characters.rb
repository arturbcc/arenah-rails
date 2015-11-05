FactoryGirl.define do
  factory :character do
    sequence(:name) { |i| "character #{i}" }
  end
end