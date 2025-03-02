class Post < ApplicationRecord
    # この記述により、PostモデルはUserモデルに属していることを示している。この記述により、Postモデルのインスタンスには、userメソッドが使えるようになる。このメソッドを使うと、その投稿に紐づいているユーザー情報を取得できる
    belongs_to :user
    # データベースのルールはここで決めるcontentカラムに対して、presence: trueを指定しているので、contentカラムには必ず値が入るようになっている。つまり、空の投稿を保存することはできないし、また、length: {maximum: 140}を指定しているので、contentカラムには140文字以内の文字列しか保存できない
    validates :content, { presence: true, length: { maximum: 140 } }
    # user_idカラムに対して、presence: trueを指定しているので、user_idカラムには必ず値が入るようになっている。つまり、空の投稿を保存することはできない
    validates :user_id, { presence: true }


    # インスタンスメソッドを定義している。このメソッドは、投稿に紐づいているユーザー情報を取得するためのもの
    def user
        User.find_by(id: self.user_id)
    end
end
