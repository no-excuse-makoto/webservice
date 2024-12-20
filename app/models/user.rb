class User < ApplicationRecord
    # nameカラムに値が入っているかどうかを検証するバリデーションを確認している
  validates :name, {presence: true}
  
  # emailカラムに関するバリデーションを行い値があるか、一意かどうかを確認している
  validates :email, {presence: true, uniqueness: true}
  
end
