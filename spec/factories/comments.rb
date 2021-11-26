FactoryBot.define do
  factory :comment do
    body { Faker::Hacker.say_something_smart }
    user
    diary
  end
end
