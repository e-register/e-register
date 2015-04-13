class CreatePresenceTypes < ActiveRecord::Migration
  def change
    create_table :presence_types do |t|
      t.string :name
      t.string :description
      t.boolean :present

      t.timestamps null: false
    end
  end
end
