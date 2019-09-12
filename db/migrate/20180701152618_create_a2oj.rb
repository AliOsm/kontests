class CreateA2oj < ActiveRecord::Migration[5.2]
  def change
    create_table :a2oj, id: false do |t|
      t.string :name
      t.string :url
      t.string :start_time
      t.string :end_time
      t.string :duration
      t.string :owner_name
      t.string :owner_url
      t.integer :registrants
      t.string :in_24_hours
      t.string :status
    end
  end
end
