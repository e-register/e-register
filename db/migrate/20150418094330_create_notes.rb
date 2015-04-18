class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :teacher_id
      t.references :notable, polymorphic: true
      t.date :date
      t.boolean :visible
      t.string :text

      t.timestamps null: false
    end
    add_index :notes, :teacher_id
    add_index :notes, [ :notable_type, :notable_id ]
    add_index :notes, :date
  end
end
