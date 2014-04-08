class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
    
    	t.integer :holiday_id
    	t.integer :price

      t.timestamps
    end
  end
end
