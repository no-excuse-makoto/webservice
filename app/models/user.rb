class User < ApplicationRecord
    # nameカラムに値が入っているかどうかを検証するバリデーションを確認している
  validates :name, {presence: true}
  
  # emailカラムに関するバリデーションを行い値があるか、一意かどうかを確認している
  validates :email, {presence: true, uniqueness: true}
  
  # passwordカラムに関するバリデーションを行い値があるかどうかを確認している
  validates :password, {presence: true}
end
