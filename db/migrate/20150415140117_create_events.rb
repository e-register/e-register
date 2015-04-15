class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :teacher_id
      t.integer :klass_id
      t.date :date
      t.string :text
      t.boolean :visible

      t.timestamps null: false
    end
    add_index :events, :teacher_id
    add_index :events, :klass_id
    add_index :events, :date
  end
end
