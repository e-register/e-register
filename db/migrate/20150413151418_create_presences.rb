class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.integer :teacher_id
      t.integer :student_id
      t.date :date
      t.integer :hour
      t.integer :presence_type_id
      t.integer :justification_id
      t.string :note

      t.timestamps null: false
    end

    add_index :presences, :teacher_id
    add_index :presences, :student_id
    add_index :presences, :date
  end
end
