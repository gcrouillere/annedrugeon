class AddCollectionToCeramiques < ActiveRecord::Migration[5.2]
  def change
    add_reference :ceramiques, :collection, foreign_key: true
  end
end
