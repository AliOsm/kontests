class CreateAll < ActiveRecord::Migration[5.2]
  def change
    create_table :all, id: false do |t|
      t.string :name
      t.string :start_time
      t.string :duration
      t.string :in_24_hours
      t.string :status
      t.string :site

      # t.timestamps
    end
  end
end
