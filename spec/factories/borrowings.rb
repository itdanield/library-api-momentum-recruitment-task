FactoryBot.define do
  factory :borrowing do
    association :book
    association :reader

    borrowed_at { Time.current }
    due_date { 30.days.from_now }
    returned_at { nil }
  end
end
