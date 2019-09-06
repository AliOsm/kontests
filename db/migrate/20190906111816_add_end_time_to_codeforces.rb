class AddEndTimeToCodeforces < ActiveRecord::Migration[5.2]
  def change
  	# We need to add end_time after start_time, so remove any column after start_time
  	remove_column :codeforces, :duration
  	remove_column :codeforces, :in_24_hours
  	remove_column :codeforces, :status

  	# Add end_time column
  	add_column :codeforces, :end_time, :string

  	# Add the previously removed columns
  	add_column :codeforces, :duration, :string
  	add_column :codeforces, :in_24_hours, :string
  	add_column :codeforces, :status, :string
  end
end
