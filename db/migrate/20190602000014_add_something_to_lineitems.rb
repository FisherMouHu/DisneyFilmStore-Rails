class AddSomethingToLineitems < ActiveRecord::Migration[5.2]
  def change
    add_column :lineitems, :quantity, :integer, default: 1
  end
end
