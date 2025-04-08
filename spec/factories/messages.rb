FactoryBot.define do
  factory :message do
    chat_room { nil }
    user { nil }
    content { "MyText" }
  end
end
