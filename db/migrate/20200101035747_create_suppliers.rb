class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :website
      t.text :address

      t.timestamps
    end
  end
end
