class AddIndexesToCredential < ActiveRecord::Migration
  def change
    add_index :credentials, :user_id
    add_index :credentials, :username, unique: true
  end
end
