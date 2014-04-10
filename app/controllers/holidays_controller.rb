class HolidaysController < ApplicationController

	def index
		@holidays = Holiday.order("created_at desc")
		@holiday = Holiday.new
	end
	
	def show 
	end
	
	def new
		redirect_to holidays_path
	end

	def create

		
		@holiday = Holiday.new(holiday_params)
		
		
		if @holiday.save
			flash[:success] = "Holiday added to your list"
			redirect_to root_path

		else
			flash[:message] = @holiday.errors.full_messages
			redirect_to root_path
		end
				
	end
	
	
	def destroy
		@holiday = Holiday.find(params[:id])
		@holiday.destroy
		flash[:success] = "Holiday has been removed from your list"
		redirect_to root_path
	end
	
	
	
	
	# Whitelisting params

	def holiday_params
		params.require(:holiday).permit(:url, :notifications)
	end

end
