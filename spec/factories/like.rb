FactoryBot.define do
    factory :like do
      # Userモデルとの関連を定義
      # いいねを作成する際に関連するユーザーを自動的に作成する
      association :user

      # Postモデルとの関連を定義
      # いいねを作成する際に関連する投稿を自動的に作成する
      association :post
    end
  end
