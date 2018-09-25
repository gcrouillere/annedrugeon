class AddFieldsToCeramiques < ActiveRecord::Migration[5.2]
  def change
    add_column :ceramiques, :dimension, :string
    add_column :ceramiques, :material, :string
    add_column :ceramiques, :gold, :boolean
    add_column :ceramiques, :packing, :string
    add_column :ceramiques, :cleaning, :string
  end
end
