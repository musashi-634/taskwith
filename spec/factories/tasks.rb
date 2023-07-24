FactoryBot.define do
  factory :task do
    association :project

    name { '3Dモデル設計' }
    start_at { '2023/7/1'.to_date }
    end_at { '2023/7/10'.to_date }
    description { '筐体と機構を優先すること。' }
    is_done { false }
    row_order { nil }

    trait :done do
      is_done { true }
    end
  end
end
