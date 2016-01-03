class ContentsController < ApplicationController

	layout 'holiday'

	def home
		if user_signed_in?
			redirect_to holidays_path
		else
			render
		end
	end
	
	def cookie_policy
		render
	end

	def privacy_policy
		render
	end


	def terms_of_service
		render
	end


end
