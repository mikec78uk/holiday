class Contact < ActiveRecord::Base

	validates :email_address, presence: true
	validates :contact_name, presence: true
	validates :message, presence: true

end
