class CreateCodeforces < ActiveRecord::Migration[5.2]
  def change
    create_table :codeforces, id: false do |t|
      t.integer :code, null: false
      t.string :name
      t.string :start_time
      t.string :duration

      # t.timestamps
    end

    add_index :codeforces, :code, unique: true
  end
end
