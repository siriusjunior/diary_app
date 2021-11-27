FactoryBot.define do
  factory :diary do
    body { Faker::Hacker.say_something_smart }
    image { File.open("#{Rails.root}/spec/fixtures/dummy.png") }
    date_sequence { 1 }
    user
  end
end
