class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :user_id
      t.integer :klass_id
      t.integer :subject_id

      t.timestamps null: false
    end
  end
end
