class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  create_table :users_roles, id: false do |t|
    t.belongs_to :user
    t.belongs_to :role
  end

end
