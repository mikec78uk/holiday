class HoldingsController < ApplicationController
	layout 'holiding-layout'

	def index
		@holding = Holding.new
	end
	
	def show 
	end
	
	def new
		@holding = Holding.new
	end

	def create
		
		@holding = Holding.new(holding_params)
		
		if @holding.save
			flash[:success] = "Thanks for subscribing. We will keep you updated!"
			redirect_to root_path

		else
			flash[:error] = "Sorry, there was a problem! Please try again"
			redirect_to root_path
		end
				
	end



	def holding_params
		params.require(:holding).permit(:email)
	end

end
