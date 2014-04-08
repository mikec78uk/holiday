class ChangeUrlFieldToText < ActiveRecord::Migration
  def change
  	change_column :holidays, :url,  :text
  end
end
