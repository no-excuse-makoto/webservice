class User < ApplicationRecord
    # nameカラムに値が入っているかどうかを検証するバリデーションを確認している
  validates :name, {presence: true}
  
  # emailカラムに関するバリデーションを行い値があるか、一意かどうかを確認している
  validates :email, {presence: true, uniqueness: true}
  
  # passwordカラムに関するバリデーションを行い値があるかどうかを確認している
  validates :password, {presence: true}

  # ユーザーが投稿した投稿をすべて取得するためのインスタンスメソッドです。このメソッドは、Userモデルに定義されている
  def posts
    return Post.where(user_id: self.id)
  end
end
