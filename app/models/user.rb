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
  # def posts
  #   Post.where(user_id: self.id)
  # end

  # この記述は、has_manyメソッドを使って、UserモデルがPostモデルに対して1対多の関係を持つことを示している。この記述により、Userモデルのインスタンスには、postsメソッドが使えるようになる。このメソッドを使うと、そのユーザーが投稿した投稿をすべて取得できる
  # psotsメソッドを使うと、そのユーザーが投稿した投稿をすべて取得できるが、has_manyメソッドを使うことで、Userモデルのインスタンスには、postsメソッドが使えるようになる
  has_many :posts



  # フォローしているユーザーとの関連
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # フォローされているユーザーとの関連
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # ユーザーのフォローを解除する
  def unfollow(other_user)
    following.delete(other_user)
  end

  # ユーザーをフォローしているか確認する
  def following?(other_user)
    following.include?(other_user)
  end

  # コメントを投稿したユーザーとの関連
  has_many :comments, dependent: :destroy
  has_many :likes
end
