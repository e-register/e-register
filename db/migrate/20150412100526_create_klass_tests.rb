class CreateKlassTests < ActiveRecord::Migration
  def change
    create_table :klass_tests do |t|
      t.integer :teacher_id
      t.date :date
      t.float :total_score
      t.integer :evaluation_scale_id
      t.string :description

      t.timestamps null: false
    end
    add_index :klass_tests, :teacher_id
  end
end
