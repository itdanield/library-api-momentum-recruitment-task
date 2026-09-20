FactoryBot.define do
  factory :reader do
    card_number { Faker::Number.number(digits: 6) }
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
