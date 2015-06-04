class AddJustificableToPresenceType < ActiveRecord::Migration
  def change
    add_column :presence_types, :justificable, :boolean, after: :present
  end
end
