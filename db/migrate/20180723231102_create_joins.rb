class CreateJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :joins do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.text :how, null: false

      t.timestamps
    end
  end
end
