# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    title { "Task Title" }
    completed { false }
    association :project
  end
end