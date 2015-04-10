class CreateEvaluationTypes < ActiveRecord::Migration
  def change
    create_table :evaluation_types do |t|
      t.string :name
    end
  end
end
