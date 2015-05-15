class AddJustifiedAtToPresences < ActiveRecord::Migration
  def change
    add_column :presences, :justified_at, :datetime, after: :note
  end
end
