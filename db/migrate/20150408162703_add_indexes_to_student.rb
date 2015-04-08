class AddIndexesToStudent < ActiveRecord::Migration
  def change
    add_index(:students, :user_id)
    add_index(:students, :klass_id)
    add_index(:students, [:user_id, :klass_id], unique: true)
  end
end
