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
		@history.price = @real_html.css("span.price-pp").text.gsub(/\D/, '').to_i
		@history.save		
	
	end
	
	# Need to deal with sold out and holidays in the past
	
		
end

task mark_as_unavailable: :environment do
	@holidays = Holiday.where(:is_live => true)
	
	@holidays.each do |holiday|
		@history_prices = History.where(:holiday_id => holiday.id)
		
		if @history_prices.map {|i| i.price }.last(2) == [0,0]
			# Update Record without invoking callbacks, i.e. before_save
			holiday.update_columns(is_live: false)
		
		end
	end
end

task email_price_change: :environment do

	
end