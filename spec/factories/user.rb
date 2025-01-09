FactoryBot.define do
    factory :user do
      name { "Test User" }
      email { "test@example.com" }
      password { "password" }
      image_name { "default_user.jpg" }
    end
  end