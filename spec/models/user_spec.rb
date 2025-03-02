require 'rails_helper'

RSpec.describe User, type: :model do
  # 有効な属性を持つユーザーが有効であることを確認するテスト
  it "is valid with valid attributes" do
    # FactoryBotを使用して有効なユーザーを作成
    user = build(:user)
    # ユーザーが有効であることを期待
    expect(user).to be_valid
  end

  # 名前がない場合にユーザーが無効であることを確認するテスト
  it "is not valid without a name" do
    # 名前がnilのユーザーを作成
    user = build(:user, name: nil)
    # ユーザーが無効であることを期待
    expect(user).not_to be_valid
  end

  # メールアドレスがない場合にユーザーが無効であることを確認するテスト
  it "is not valid without an email" do
    # メールアドレスがnilのユーザーを作成
    user = build(:user, email: nil)
    # ユーザーが無効であることを期待
    expect(user).not_to be_valid
  end

  # 一意のメールアドレスがない場合にユーザーが無効であることを確認するテスト
  it "is not valid without a unique email" do
    # 既存のメールアドレスを持つユーザーを作成
    create(:user, email: "test@example.com")
    # 同じメールアドレスを持つ新しいユーザーを作成
    user = build(:user, email: "test@example.com")
    # 新しいユーザーが無効であることを期待
    expect(user).not_to be_valid
  end

  # ユーザーが正しい投稿を返すことを確認するテスト
  it "returns the correct posts" do
    # ユーザーを作成
    user = create(:user)
    # ユーザーに関連する投稿を2つ作成
    post1 = create(:post, user: user)
    post2 = create(:post, user: user)
    # ユーザーの投稿が作成した投稿を含むことを期待
    expect(user.posts).to include(post1, post2)
  end
end
