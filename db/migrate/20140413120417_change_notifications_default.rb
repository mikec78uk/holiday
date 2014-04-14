class ChangeNotificationsDefault < ActiveRecord::Migration
  def change
  
  	change_column :holidays, :notifications, :boolean, :default => true
  	add_column :holidays, :last_emailed, :integer
  	add_column :holidays, :is_live, :boolean, :default => true
  
  
  end
end
