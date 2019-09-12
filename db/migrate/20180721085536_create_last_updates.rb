class CreateLastUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :last_updates do |t|
      t.string :site
      t.datetime :date
    end
  end
end
