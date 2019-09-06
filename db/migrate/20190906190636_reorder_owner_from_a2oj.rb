class ReorderOwnerFromA2oj < ActiveRecord::Migration[5.2]
  def change
  	remove_column :a2oj, :owner
  	remove_column :a2oj, :start_time
  	remove_column :a2oj, :end_time
  	remove_column :a2oj, :duration
  	remove_column :a2oj, :registrants
  	remove_column :a2oj, :type_
  	remove_column :a2oj, :registration
  	remove_column :a2oj, :in_24_hours
  	remove_column :a2oj, :status

  	add_column :a2oj, :start_time, :string
  	add_column :a2oj, :end_time, :string
  	add_column :a2oj, :duration, :string
  	add_column :a2oj, :owner, :string
  	add_column :a2oj, :registrants, :string
  	add_column :a2oj, :type_, :string
  	add_column :a2oj, :registration, :string
  	add_column :a2oj, :in_24_hours, :string
  	add_column :a2oj, :status, :string
  end
end
