class AddEndTimeToCsAcademy < ActiveRecord::Migration[5.2]
  def change
  	# We need to add end_time after start_time, so remove any column after start_time
  	remove_column :at_coder, :duration
  	remove_column :at_coder, :in_24_hours
  	remove_column :at_coder, :status

  	# Add end_time column
  	add_column :at_coder, :end_time, :string

  	# Add the previously removed columns
  	add_column :at_coder, :duration, :string
  	add_column :at_coder, :in_24_hours, :string
  	add_column :at_coder, :status, :string
  end
end
