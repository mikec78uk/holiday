class HolidaysUpdateForgotSave < ActiveRecord::Migration
  def change
  
  		
		add_column :holidays, :url, :string
		add_column :holidays, :initial_price, :integer
		add_column :holidays, :hotel_name, :string
		add_column :holidays, :duration, :string
		add_column :holidays, :location, :string
		add_column :holidays, :flights, :string
		add_column :holidays, :party_size, :string
		add_column :holidays, :image_url, :string
		add_column :holidays, :company, :string
		add_column :holidays, :notifications, :boolean
  end
end
