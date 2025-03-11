class AddAnonymousToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :anonymous, :boolean, default: false
  end
end
