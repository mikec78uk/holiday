class ContactsController < ApplicationController



	def new
		@contact = Contact.new
	end

	def create
		@contact = Contact.new(contact_params)
		

		if @contact.save
			
			ContactMailer.contact(@contact).deliver
			flash[:success] = "Your message has been sent."
			redirect_to new_contact_path
		else
			flash[:error] = "Sorry, there was a problem. Please try again"
			render "new"
		end

	end

	def contact_params
		params.require(:contact).permit(:email_address, :contact_name, :message)
	end

end
