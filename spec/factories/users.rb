FactoryBot.define do
  factory :user do
    name { '山田　太郎' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'f4k3p455w0rd' }

    trait :invalid do
      name { nil }
      email { nil }
      password { nil }
    end

    trait :with_organization do
      association :organization
    end
  end
end
