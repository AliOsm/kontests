class ReorderTypeFromHackerEarth < ActiveRecord::Migration[5.2]
  def change
  	remove_column :hacker_earth, :type_
  	remove_column :hacker_earth, :start_time
  	remove_column :hacker_earth, :end_time
  	remove_column :hacker_earth, :duration
  	remove_column :hacker_earth, :in_24_hours
  	remove_column :hacker_earth, :status

  	add_column :hacker_earth, :start_time, :string
  	add_column :hacker_earth, :end_time, :string
  	add_column :hacker_earth, :duration, :string
  	add_column :hacker_earth, :type_, :string
  	add_column :hacker_earth, :in_24_hours, :string
  	add_column :hacker_earth, :status, :string
  end
end
