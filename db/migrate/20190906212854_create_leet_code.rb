class CreateLeetCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :leet_code, id: false do |t|
    	t.string :name
      t.string :start_time
      t.string :end_time
      t.string :duration
      t.string :in_24_hours
      t.string :status

      # t.timestamps
    end
  end
end
