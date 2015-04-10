class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.float :value
      t.string :as_string, null: false
      t.boolean :is_counted, null: false
    end
  end
end
