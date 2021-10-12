class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :phone
      t.string :password_digest
      t.boolean :email_confirm
      t.boolean :phone_confirm
      t.boolean :is_active
      t.text :groups
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :phone, unique: true
  end
end
