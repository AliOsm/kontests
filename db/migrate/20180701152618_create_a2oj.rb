class CreateA2oj < ActiveRecord::Migration[5.2]
  def change
    create_table :a2oj, id: false do |t|
      t.integer :code, null: false
      t.string :name
      t.string :owner
      t.string :start_time
      t.string :before_start
      t.string :duration
      t.string :registrants
      t.string :type_
      t.string :registration
      t.string :in_24_hours

      # t.timestamps
    end

    add_index :a2oj, :code, unique: true
  end
end
