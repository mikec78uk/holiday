task daily_price: :environment do
	

	# Find all holidays with thomson in url
	
	@thomson = Holiday.where("url like ?", "%thomson%").to_a
	
	# for each one get the latest price
	
	@thomson.each do |holiday|
		
		# Get the raw html
		@raw_html = HTTParty.get(holiday.url)
		
		# lets turn the raw html into real HTML we can parse
		@real_html = Nokogiri::HTML(@raw_html)
		
		@history = History.new
		@history.holiday_id = holiday.id
		@history.price = @real_html.css("span.price-total").text.gsub(/[^0-9,.]/, "").to_i
		@history.save		
	
	end
	
	
	@firstchoice = Holiday.where("url like ?", "%firstchoice%").to_a
	
		@firstchoice.each do |holiday|
		
		# Get the raw html
		@raw_html = HTTParty.get(holiday.url)
		
		# lets turn the raw html into real HTML we can parse
		@real_html = Nokogiri::HTML(@raw_html)
		
		@history = History.new
		@history.holiday_id = holiday.id
		@history.price = @real_html.css("span.price-total").text.gsub(/\D/, '').to_i
		@history.save		
	
	end
	



end

task mark_as_unavailable: :environment do
	@holidays = Holiday.where(:is_live => true)
	
	@holidays.each do |holiday|
		@history_prices = History.where(:holiday_id => holiday.id).order("created_at")
		
		if @history_prices.map {|i| i.price }.last(2) == [0,0]
			# Send email to user if notifications is true
			if holiday.notifications == true
				# send email
				NotificationMailer.holiday_unavailable(holiday).deliver
			end

			# Update Record without invoking callbacks, i.e. before_save
			holiday.update_columns(is_live: false)
		
		end
	end
end


# Removes unavailable holidays - do this once a week 
task remove_dead_holidays: :environment do
		@holidays = Holiday.where(:is_live => false)

		@holidays.each do |holiday|
			@history_prices = History.where(:holiday_id => holiday.id)
		
			@history_prices.each do |history|
				history.destroy
			end

			holiday.destroy
		end
end

# Keeps Histories limited to 7 after Heroku warning about database row limit
task reduce_histories: :environment do
	# Get all unique holiday_id values
	@histories = History.uniq.pluck(:holiday_id)

	# Run through each to keep the last 7
	@histories.each do |x|
		# Get each one, order by created date, keep the last 7 and delete
		History.where(holiday_id: x).order('created_at DESC').offset(7).destroy_all
	end

end




task email_price_change: :environment do
	# Find holidays where the price changed but doesn't equal 0
	@holidays = Holiday.where(:is_live => true)

	@holidays.each do |holiday|
		# get the last price in the history
		# added order otherwise defaults to sort by your primary key (usually id).
		@last_price = History.where(:holiday_id => holiday.id).order("created_at").map {|i| i.price }.last
			
			# ignore the ones where the last price was zero
			if @last_price != 0
				# price has gone up
				if @last_price > holiday.last_emailed
					# email user
					NotificationMailer.holiday_increased(holiday, @last_price).deliver
					#update last emailed
					holiday.update_columns(last_emailed: @last_price)
				end
				
				if @last_price < holiday.last_emailed
					# email user
					NotificationMailer.holiday_decreased(holiday, @last_price).deliver
					#update last emailed
					holiday.update_columns(last_emailed: @last_price)
				end

			end
	end	

end