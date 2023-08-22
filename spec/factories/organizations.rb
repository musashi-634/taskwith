FactoryBot.define do
  factory :organization do
    name { '株式会社JMD' }

    trait :invalid do
      name { nil }
    end
  end
end
