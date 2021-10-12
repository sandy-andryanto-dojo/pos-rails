class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :type_of
      t.boolean :status
      t.string :invoice_number
      t.date :invoice_date
      t.references :supplier, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :user, foreign_key: true
      t.float :total_items
      t.float :subtotal
      t.float :discount
      t.float :tax
      t.float :grandtotal
      t.float :cash
      t.float :change
      t.text :notes

      t.timestamps
    end
  end
end
