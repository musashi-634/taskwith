FactoryBot.define do
  factory :task do
    association :project

    name { '3Dモデル設計' }

    trait :invalid do
      name { nil }
    end

    trait :done do
      is_done { true }
    end

    factory :task_with_time_span do
      start_at { Time.zone.now }
      end_at { start_at }
    end
  end
end
