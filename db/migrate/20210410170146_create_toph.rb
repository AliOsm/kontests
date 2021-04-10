class CreateToph < ActiveRecord::Migration[6.1]
  def change
    create_table :toph, id: false do |t|
	    t.string :name
      t.string :url
      t.string :start_time
      t.string :end_time
      t.string :duration
      t.string :in_24_hours
      t.string :status
    end
  end
end
