class CreateCsAcademy < ActiveRecord::Migration[5.2]
  def change
    create_table :cs_academy, id: false do |t|
      t.string :name
      t.string :start_time
      t.string :duration

      # t.timestamps
    end
  end
end
