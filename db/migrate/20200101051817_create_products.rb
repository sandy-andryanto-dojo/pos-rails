class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :name
      t.string :image
      t.references :brand, foreign_key: true
      t.references :type, foreign_key: true
      t.references :supplier, foreign_key: true
      t.float :stock
      t.float :price_purchase
      t.float :price_sales
      t.decimal :price_profit
      t.date :date_expired
      t.text :description
      t.text :notes

      t.timestamps
    end
  end

  create_table :products_categories, id: false do |t|
    t.belongs_to :product
    t.belongs_to :category
  end

end
