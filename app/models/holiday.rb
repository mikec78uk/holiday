class Holiday < ActiveRecord::Base



	

	validates :url, presence: true
	#validates_inclusion_of :url, :in =>
	#%w(thomson firstchoice)
	#, :message => " only allow FedEx or USPS"
    
    
    
    before_save do
    
	    if self.url.include? "thomson"
	    
	    	# get the raw html from reddit	
			@raw_html = HTTParty.get(self.url)
			
			# lets turn the raw html into real HTML we can parse
			@real_html = Nokogiri::HTML(@raw_html)		
			# in css we would style up the title links using div#siteTable a.title
			# Use the css selector to get the relvant bits of the page
				

				#@holiday = Holiday.new
				# Get price, removes £ and turns to integer
				self.initial_price = @real_html.css("span.price-total").text.gsub(/[^0-9,.]/, "").to_i			
				#@real_html.css("span.price-total").each do |price|
				#	@prie_int = price.text.tr('£','').to_i
				#	self.initial_price = @prie_int
				#end




				self.hotel_name = @real_html.css("span.inline-title").text.delete("\n")
				#@holiday.duration
				self.location = @real_html.css("p#breadcrumbs").text.delete("\n").delete("\r")
				self.flights = @real_html.css("span.airport").text
				

				# Gets party comp and removes " change"
				self.party_size = @real_html.css("span.party-composition").text.delete("|")[0..-8]
				
				
				self.company = "thomson"
				
				@real_html.css("ul.plist").children.first.search('img').each do |img|
					self.image_url = img['src']
				end

				
	    end

	    if self.url.include? "firstchoice"

	    	self.url = "a firstchoice url"
	    
	    end
	    
    
    
    end
    
    
    
end
