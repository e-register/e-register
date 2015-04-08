class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.string :name
      t.string :detail

      t.timestamps null: false
    end
  end
end
