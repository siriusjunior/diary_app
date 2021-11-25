FactoryBot.define do
  factory :diary do
    body { Faker::Hacker.say_something_smart }
    image { [File.open("#{Rails.root}/spec/fixtures/dummy.png")] }
    user
  end
end
