require 'rails_helper'

RSpec.describe Like, type: :model do
  # 有効な属性を持ついいねが有効であることを確認するテスト
  it "is valid with valid attributes" do
    # FactoryBotを使用して有効ないいねを作成
    user = create(:user)
    # userに関連する投稿を作成
    post = create(:post, user: user)
    # ここで作成した投稿に対していいねを作成
    like = build(:like, user: user, post: post)
    # いいねが有効であることを期待
    expect(like).to be_valid
  end

  # user_idがない場合にいいねが無効であることを確認するテスト
  it "is not valid without a user_id" do
    # user_idがnilのいいねを作成
    post = create(:post)
    like = build(:like, user: nil, post: post)
    # いいねが無効であることを期待
    expect(like).not_to be_valid
  end

  # post_idがない場合にいいねが無効であることを確認するテスト
  it "is not valid without a post_id" do
    # post_idがnilのいいねを作成
    user = create(:user)
    like = build(:like, user: user, post: nil)
    # いいねが無効であることを期待
    expect(like).not_to be_valid
  end
end