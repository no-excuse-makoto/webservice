FactoryBot.define do
    factory :post do
      content { "Test content" }
      association :user
    end
  end