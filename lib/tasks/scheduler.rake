task daily_price: :environment do
	

	# Find all holidays with thomson in url
	
	@thomson = Holiday.where("url like ?", "%thomson%").to_a
	
	# for each one get the latest price
	
	@thomson.each do |holiday|
	
		#encode url properly
		#url = URI.encode(holiday.url)
		#@url = URI.parse(URI.encode(holiday.url.strip))
		
		#encoded_url = URI.encode(holiday.url)
		
		#url = URI.encode(holiday.url,"[]")
		
		#url = URI.escape(holiday.url)
	
		# Get the raw html
		@raw_html = HTTParty.get(holiday.url)
		
		# lets turn the raw html into real HTML we can parse
		@real_html = Nokogiri::HTML(@raw_html)
		
		@history = History.new
		@history.holiday_id = holiday.id
		@history.price = @real_html.css("span.price-total").text.gsub(/[^0-9,.]/, "").to_i
		@history.save
		
		
	
	end
	
		
end
