FactoryBot.define do
  factory :project do
    title { "Sample Project" }
    association :user
  end
end
