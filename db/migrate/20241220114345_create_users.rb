class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.timestamps
      

      
    end
    #データベースレベルでの一意性を保証するために、emailカラムにインデックスを追加している。モデルだけではなく、データベースにも一意性を持たせることができる
      add_index :users, :email, unique: true
  end
end
