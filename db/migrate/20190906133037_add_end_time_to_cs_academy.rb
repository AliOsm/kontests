class AddEndTimeToCsAcademy < ActiveRecord::Migration[5.2]
  def change
  	# We need to add end_time after start_time, so remove any column after start_time
  	remove_column :cs_academy, :duration
  	remove_column :cs_academy, :in_24_hours
  	remove_column :cs_academy, :status

  	# Add end_time column
  	add_column :cs_academy, :end_time, :string

  	# Add the previously removed columns
  	add_column :cs_academy, :duration, :string
  	add_column :cs_academy, :in_24_hours, :string
  	add_column :cs_academy, :status, :string
  end
end
