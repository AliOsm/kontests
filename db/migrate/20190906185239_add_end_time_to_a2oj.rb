class AddEndTimeToA2oj < ActiveRecord::Migration[5.2]
  def change
  	# We need to add end_time after start_time, so remove any column after start_time
  	remove_column :a2oj, :duration
  	remove_column :a2oj, :registrants
  	remove_column :a2oj, :type_
  	remove_column :a2oj, :registration
  	remove_column :a2oj, :in_24_hours
  	remove_column :a2oj, :status

  	# Add end_time column
  	add_column :a2oj, :end_time, :string

  	# Add the previously removed columns
  	add_column :a2oj, :duration, :string
  	add_column :a2oj, :registrants, :string
  	add_column :a2oj, :type_, :string
  	add_column :a2oj, :registration, :string
  	add_column :a2oj, :in_24_hours, :string
  	add_column :a2oj, :status, :string
  end
end
