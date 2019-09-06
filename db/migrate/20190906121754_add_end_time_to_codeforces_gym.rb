class AddEndTimeToCodeforcesGym < ActiveRecord::Migration[5.2]
  def change
  	# We need to add end_time after start_time, so remove any column after start_time
  	remove_column :codeforces_gym, :duration
  	remove_column :codeforces_gym, :difficulty
  	remove_column :codeforces_gym, :in_24_hours
  	remove_column :codeforces_gym, :status

  	# Add end_time column
  	add_column :codeforces_gym, :end_time, :string

  	# Add the previously removed columns
  	add_column :codeforces_gym, :duration, :string
  	add_column :codeforces_gym, :difficulty, :string
  	add_column :codeforces_gym, :in_24_hours, :string
  	add_column :codeforces_gym, :status, :string
  end
end
