FactoryBot.define do
  factory :project do
    name { '新製品開発' }
    description { '大規模病院向けの製品です。' }
    is_done { false }
  end
end
