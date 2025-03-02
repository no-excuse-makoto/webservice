require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }

  it "allows a user to log in and log out" do
    # ユーザーとしてログイン
    visit login_path
    fill_in "email", with: user.email  # フィールド名を正しく設定
    fill_in "password", with: user.password  # フィールド名を正しく設定
    click_button "ログイン"

    # ログインが成功したことを確認
    expect(page).to have_content("ログインしました")

    # ログアウト
    click_link "ログアウト"

    # ログアウトが成功したことを確認
    expect(page).to have_content("ログアウトしました")
  end
end
