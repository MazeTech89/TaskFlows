FactoryBot.define do
  factory :task do
    name { "Sample Task" }
    completed { false }
    association :project
  end
end
