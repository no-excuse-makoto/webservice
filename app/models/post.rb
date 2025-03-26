class Post < ApplicationRecord
    # この記述により、PostモデルはUserモデルに属していることを示している。この記述により、Postモデルのインスタンスには、userメソッドが使えるようになる。このメソッドを使うと、その投稿に紐づいているユーザー情報を取得できる
    belongs_to :user

    # 自、これによって、PostモデルはCategoryモデルに属していることを示している。この記述により、Postモデルのインスタンスには、categoryメソッドが使えるようになる。このメソッドを使うと、その投稿に紐づいているカテゴリー情報を取得できる
    belongs_to :category

    # データベースのルールはここで決めるcontentカラムに対して、presence: trueを指定しているので、contentカラムには必ず値が入るようになっている。つまり、空の投稿を保存することはできないし、また、length: {maximum: 140}を指定しているので、contentカラムには140文字以内の文字列しか保存できない
    validates :content, { presence: true, length: { maximum: 140 } }
    # user_idカラムに対して、presence: trueを指定しているので、user_idカラムには必ず値が入るようになっている。つまり、空の投稿を保存することはできない
    validates :user_id, { presence: true }

    # category_idカラムに対して、presence: trueを指定しているので、category_idカラムには必ず値が入るようになっている。つまり、空の投稿を保存することはできない
    validates :category_id, presence: true

    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags
    
    # この記述により、PostモデルはLikeモデルに属していることを示している。この記述により、Postモデルのインスタンスには、likesメソッドが使えるようになる。このメソッドを使うと、その投稿に紐づいているいいね情報を取得できる
    has_many :likes
    has_many :comments, dependent: :destroy
    


    # インスタンスメソッドを定義している。このメソッドは、投稿に紐づいているユーザー情報を取得するためのもの
    # def user
    #     User.find_by(id: self.user_id)
    # end
end
