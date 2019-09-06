class AddEndTimeToAll < ActiveRecord::Migration[5.2]
  def change
  	# We need to add end_time after start_time, so remove any column after start_time
  	remove_column :all, :duration
  	remove_column :all, :in_24_hours
  	remove_column :all, :status
  	remove_column :all, :site

  	# Add end_time column
  	add_column :all, :end_time, :string

  	# Add the previously removed columns
  	add_column :all, :duration, :string
  	add_column :all, :in_24_hours, :string
  	add_column :all, :status, :string
  	add_column :all, :site, :string
  end
end
