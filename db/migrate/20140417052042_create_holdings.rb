class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|
    	t.string :email
      t.timestamps
    end
  end
end
