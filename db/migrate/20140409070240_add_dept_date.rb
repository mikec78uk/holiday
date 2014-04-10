class AddDeptDate < ActiveRecord::Migration
  def change
  
  	add_column :holidays, :dept_date,  :string
  
  end
end
