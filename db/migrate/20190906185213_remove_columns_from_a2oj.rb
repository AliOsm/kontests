class RemoveColumnsFromA2oj < ActiveRecord::Migration[5.2]
  def change
  	remove_column :a2oj, :before_start
  	remove_column :a2oj, :before_end
  end
end
