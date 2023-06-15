FactoryBot.define do
  factory :project do
    name { '新製品開発' }
    description { '大規模病院向けの製品です。' }
    is_done { false }
    is_archived { false }

    trait :done do
      is_done { true }
    end

    trait :archived do
      is_archived { true }
    end
  end
end
