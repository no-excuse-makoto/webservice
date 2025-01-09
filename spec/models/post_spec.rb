require 'rails_helper'

RSpec.describe Post, type: :model do
  # 有効な属性を持つ投稿が有効であることを確認するテスト
  it "is valid with valid attributes" do
    # FactoryBotを使用して有効な投稿を作成
    user = create(:user)
    post = build(:post, user: user)
    # 投稿が有効であることを期待
    expect(post).to be_valid
  end

  # contentがない場合に投稿が無効であることを確認するテスト
  it "is not valid without content" do
    # contentがnilの投稿を作成
    user = create(:user)
    post = build(:post, content: nil, user: user)
    # 投稿が無効であることを期待
    expect(post).not_to be_valid
  end

  # contentが140文字を超える場合に投稿が無効であることを確認するテスト
  it "is not valid with content longer than 140 characters" do
    # contentが141文字の投稿を作成
    user = create(:user)
    post = build(:post, content: "a" * 141, user: user)
    # 投稿が無効であることを期待
    expect(post).not_to be_valid
  end

  # user_idがない場合に投稿が無効であることを確認するテスト
  it "is not valid without a user_id" do
    # user_idがnilの投稿を作成
    post = build(:post, user: nil)
    # 投稿が無効であることを期待
    expect(post).not_to be_valid
  end

  # 投稿に紐づいているユーザー情報を取得するインスタンスメソッドのテスト
  it "returns the correct user" do
    # ユーザーを作成
    user = create(:user)
    # ユーザーに関連する投稿を作成
    post = create(:post, user: user)
    # 投稿に紐づいているユーザー情報が正しいことを期待
    expect(post.user).to eq(user)
  end
end