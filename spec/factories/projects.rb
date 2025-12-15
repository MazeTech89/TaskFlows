# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    name { "Project Name" }
    description { "Project description" }
    association :user
  end
end