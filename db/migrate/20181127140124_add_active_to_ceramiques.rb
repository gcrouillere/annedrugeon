class AddActiveToCeramiques < ActiveRecord::Migration[5.2]
  def change
    add_column :ceramiques, :active, :boolean
    add_column :basketlines, :ceramique_id_on_order, :int
  end
end
