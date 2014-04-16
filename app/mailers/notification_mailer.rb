class NotificationMailer < ActionMailer::Base
  
  default from: "no-reply@holidaytracker.co.uk"
  
  
  
  def holiday_decreased(holiday, price)
  	@holiday = holiday
  	
  	@user = @holiday.user
    
  	@last_price = price
  
  	mail to: @user.email, subject: "Great News, your holiday price has gone down"  
  end
  
  def holiday_increased(holiday, price)
  	@holiday = holiday
  	
  	@user = @holiday.user
    
  	@last_price = price


  	mail to: @user.email, subject: "Your holiday price has increased"  
  end 
  
  def holiday_unavailable(holiday)
  	@holiday = holiday
  	
  	@user = @holiday.user
  
  	mail to: @user.email, subject: "Holiday no longer available"  
  end 


end
