class ChangePriceToString < ActiveRecord::Migration
  def change

  	change_column :holidays, :initial_price,  :string

  end
end
