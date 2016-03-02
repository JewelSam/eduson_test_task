FactoryGirl.define do
  factory :medium do
    user
    name Faker::Lorem.word
  end
end
