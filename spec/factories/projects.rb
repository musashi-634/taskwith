FactoryBot.define do
  factory :project do
    association :organization

    name { '新製品開発' }

    trait :invalid do
      name { nil }
    end

    trait :done do
      is_done { true }
    end

    trait :archived do
      is_archived { true }
    end

    factory :custom_project do
      name { 'custom project' }
    end
  end
end
