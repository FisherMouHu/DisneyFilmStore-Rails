class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :image
      t.numeric :price

      t.timestamps
    end
  end
end
