class CreateTopcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :topcategories do |t|
      t.string :name
      t.timestamps
    end
    add_reference :categories, :topcategory, foreign_key: true
  end
end
