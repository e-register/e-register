class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :teacher_id
      t.integer :student_id
      t.date :date
      t.integer :klass_test_id
      t.integer :score_id
      t.float :score_points
      t.float :total_score
      t.integer :evaluation_scale_id
      t.integer :evaluation_type_id
      t.string :description
      t.boolean :visible

      t.timestamps null: false
    end
    add_index :evaluations, :teacher_id
    add_index :evaluations, :student_id
    add_index :evaluations, :klass_test_id
  end
end
