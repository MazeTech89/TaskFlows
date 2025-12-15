FactoryBot.define do
  factory :project do
    name { "Sample Project" }
    description { "Project description" }
    association :user
  end
end
