class RemoveNotNullOnCollection < ActiveRecord::Migration[5.2]
  def change
    change_column_null :collections, :name, true
    change_column_null :collections, :description, true
  end
end
