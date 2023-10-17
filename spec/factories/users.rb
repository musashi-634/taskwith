FactoryBot.define do
  factory :user do
    name { '山田　太郎' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'f4k3p455w0rd' }
    password_confirmation { password }

    trait :invalid do
      name { nil }
      email { nil }
      password { nil }
    end

    trait :with_organization do
      association :organization
    end

    factory :custom_user do
      name { 'custom user' }
      email { 'custom@example.com' }
      password { 'custompassword' }
    end

    factory :guest_user do
      name { 'guest user' }
      email { User::GUEST_EMAIL }
    end
  end
end
