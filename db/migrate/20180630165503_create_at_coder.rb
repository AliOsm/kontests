class CreateAtCoder < ActiveRecord::Migration[5.2]
  def change
    create_table :at_coder, id: false do |t|
      t.string :id, null: false
      # t.string :url
      t.string :name
      t.string :duration
      t.string :start_time
      t.string :participate
      t.string :rated

      # t.timestamps
    end

    add_index :at_coder, :id, unique: true
  end
end
