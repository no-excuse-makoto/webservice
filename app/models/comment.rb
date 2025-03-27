class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 返信元のコメント
  belongs_to :parent, class_name: "Comment", optional: true, foreign_key: :reply_to

  # 返信されたコメント
  has_many :replies, class_name: "Comment", foreign_key: :reply_to, dependent: :destroy

  validates :content, presence: true
end
