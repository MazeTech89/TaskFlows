FactoryBot.define do
  factory :task do
    title { "Sample Task" }
    status { "incomplete" }
    association :project
  end
end
