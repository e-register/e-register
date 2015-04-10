class CreateEvaluationScales < ActiveRecord::Migration
  def change
    create_table :evaluation_scales do |t|
      t.text :checkpoints

      t.timestamps null: false
    end
  end
end
