class CreateA2oj < ActiveRecord::Migration[5.2]
  def change
    create_table :a2oj, id: false do |t|
      t.integer :code, null: false
      t.string :name
      t.string :start_time
      t.string :end_time
      t.string :duration
      t.string :owner
      t.string :registrants
      t.string :type_
      t.string :registration
      t.string :in_24_hours
      t.string :status

      # t.timestamps
    end

    add_index :a2oj, :code, unique: true
  end
end
