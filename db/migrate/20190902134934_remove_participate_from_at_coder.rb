class RemoveParticipateFromAtCoder < ActiveRecord::Migration[5.2]
  def change
  	remove_column :at_coder, :participate
  end
end
