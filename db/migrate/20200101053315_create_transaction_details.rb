class CreateTransactionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_details do |t|
      t.references :transaction, foreign_key: true
      t.references :product, foreign_key: true
      t.float :price
      t.float :qty
      t.float :total

      t.timestamps
    end
  end
end
