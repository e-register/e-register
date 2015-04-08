class AddIndexesToTeacher < ActiveRecord::Migration
  def change
    add_index(:teachers, :user_id)
    add_index(:teachers, :klass_id)
    add_index(:teachers, :subject_id)
    add_index(:teachers, [ :user_id, :klass_id, :subject_id ], unique: true)
  end
end
