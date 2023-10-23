FactoryBot.define do
  factory :organization do
    name { '株式会社JMD' }

    trait :invalid do
      name { nil }
    end

    factory :custom_organization do
      name { 'custom organization' }
    end
  end
end
