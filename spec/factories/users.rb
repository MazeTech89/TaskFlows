# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
  end
end

