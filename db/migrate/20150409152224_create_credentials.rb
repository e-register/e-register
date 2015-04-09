class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.integer :user_id
      t.string :username
      t.string :password_hash

      t.timestamps null: false
    end
  end
end
