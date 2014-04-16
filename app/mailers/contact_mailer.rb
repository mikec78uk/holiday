class ContactMailer < ActionMailer::Base
  default from: "contact@holidaytracker.co.uk"


  def contact(contact)
  	
  	@contact = contact
  
  	mail to: 'clarke.michael.j@gmail.com', subject: "Contact from holidaytracker.co.uk"  
  
  end



end
