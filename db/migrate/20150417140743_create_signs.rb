class CreateSigns < ActiveRecord::Migration
  def change
    create_table :signs do |t|
      t.integer :teacher_id
      t.integer :subject_id
      t.integer :klass_id
      t.date :date
      t.integer :hour
      t.string :lesson

      t.timestamps null: false
    end
    add_index :signs, :teacher_id
    add_index :signs, :subject_id
    add_index :signs, :klass_id
    add_index :signs, :date
  end
end
