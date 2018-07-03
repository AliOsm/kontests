class CreateSuggests < ActiveRecord::Migration[5.2]
  def change
    create_table :suggests do |t|
      t.string :site, null: false
      t.string :email, default: ''
      t.text :message, default: ''

      t.timestamps
    end
  end
end
