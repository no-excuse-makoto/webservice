class AddImageNameToUsers < ActiveRecord::Migration[7.2]
  # このファイルは、usesテーブルにimage_nameカラムを追加するためのマイグレーションファイルです。db/migrate/にあるファイルは、rails db:migrateコマンドを実行することで、データベースに変更を加えるためのファイルです。
  def change
    # usersテーブルにimage_nameカラムを追加する
    add_column :users, :image_name, :string
  end
end
