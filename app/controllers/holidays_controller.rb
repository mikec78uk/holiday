class HolidaysController < ApplicationController
	
	
	#Make sure logged in for all actions
	before_action :authenticate_user! 
	
	layout 'holiday'

	def index
		@holidays = current_user.holidays.where(:is_live => true).order("created_at desc")
		@holiday = Holiday.new
	end
	
	def show 
	end
	
	def new
		redirect_to holidays_path
	end

	def create

		
		@holiday = Holiday.new(holiday_params)
		@holiday.user_id = current_user.id
		
		if @holiday.save
			flash[:success] = "Your holiday has been added to your list, we'll notify you if the price changes"
			redirect_to holidays_path

		else
			flash[:message] = @holiday.errors.full_messages
			redirect_to holidays_path
		end
				
	end
	
	
	def destroy
		@holiday = Holiday.find(params[:id])
		@history_prices = History.where(:holiday_id => @holiday.id)
		
		
		@history_prices.each do |history|
			history.destroy
		end
				
		@holiday.destroy
		
		
		flash[:success] = "Holiday has been removed from your watchlist"
		redirect_to holidays_path
	end
	
	def delete_all_holidays
		@holidays = current_user.holidays.where(:is_live => true)

		@holidays.each do |holiday|
			@history_prices = History.where(:holiday_id => holiday.id)

			@history_prices.each do |history|
				history.destroy
			end
				
			holiday.destroy

		end

		# <%=link_to "Drive", :controller => "holidays", :action => "delete_all_holidays" %>
		flash[:message] = "All holidays have been removed"
		redirect_to root_path

	end

	
	# Whitelisting params

	def holiday_params
		params.require(:holiday).permit(:url, :notifications)
	end

end
