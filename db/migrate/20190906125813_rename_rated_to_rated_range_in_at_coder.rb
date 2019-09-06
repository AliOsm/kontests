class RenameRatedToRatedRangeInAtCoder < ActiveRecord::Migration[5.2]
  def change
  	rename_column :at_coder, :rated, :rated_range
  end
end
