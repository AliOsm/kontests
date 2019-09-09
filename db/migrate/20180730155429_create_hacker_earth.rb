class CreateHackerEarth < ActiveRecord::Migration[5.2]
  def change
    create_table :hacker_earth, id: false do |t|
      t.string :company
      t.string :name
      t.string :url
      t.string :start_time
      t.string :end_time
      t.string :duration
      t.string :type_
      t.string :in_24_hours
      t.string :status

      # t.timestamps
    end
  end
end
