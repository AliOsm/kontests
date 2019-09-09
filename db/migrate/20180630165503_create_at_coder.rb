class CreateAtCoder < ActiveRecord::Migration[5.2]
  def change
    create_table :at_coder, id: false do |t|
      t.string :code, null: false
      t.string :name
      t.string :url
      t.string :start_time
      t.string :end_time
      t.string :duration
      t.string :rated_range
      t.string :in_24_hours
      t.string :status

      # t.timestamps
    end

    add_index :at_coder, :code, unique: true
  end
end
