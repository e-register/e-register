class CreateJustifications < ActiveRecord::Migration
  def change
    create_table :justifications do |t|
      t.string :reason

      t.timestamps null: false
    end
  end
end
