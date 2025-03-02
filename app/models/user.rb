class User < ApplicationRecord
  # has_secure_passwordメソッドを使うことで、パスワードをハッシュ化して保存することができる
  has_secure_password

  # nameカラムに値が入っているかどうかを検証するバリデーションを確認している
  validates :name, { presence: true }

  # emailカラムに関するバリデーションを行い値があるか、一意かどうかを確認している
  validates :email, { presence: true, uniqueness: true }

  # passwordカラムに関するバリデーションを行い値があるかどうかを確認しているが、has_secure_passwordメソッドを使うことで、パスワードをハッシュ化して保存することができるのでいらない
  # validates :password, {presence: true}

  # ユーザーが投稿した投稿をすべて取得するためのインスタンスメソッドです。このメソッドは、Userモデルに定義されている
  def posts
    Post.where(user_id: self.id)
  end
end
