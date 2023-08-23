FactoryBot.define do
  factory :task do
    association :project

    name { '3Dモデル設計' }

    trait :done do
      is_done { true }
    end
  end
end
