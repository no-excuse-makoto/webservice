class AddReplyToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :reply_to, :integer
  end
end
