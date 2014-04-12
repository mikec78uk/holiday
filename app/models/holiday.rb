class Holiday < ActiveRecord::Base

	has_many :histories
	
	after_save :add_first_history
	
	validates :url, presence: true
	validate :must_be_thomson_or_firstchoice, :must_contain_package_id


	before_validation do
		self.url = URI.encode(self.url)
	end
    
        
    before_save do
    
	    if self.url.include? "thomson"
	    
	    	# get the raw html from reddit	
			@raw_html = HTTParty.get(self.url)

			# lets turn the raw html into real HTML we can parse
			@real_html = Nokogiri::HTML(@raw_html)		
			# in css we would style up the title links using div#siteTable a.title
			# Use the css selector to get the relvant bits of the page
				
				# Get price, removes Â£ and turns to integer
				self.initial_price = @real_html.css("span.price-total").text.gsub(/[^0-9,.]/, "").to_i			

				self.hotel_name = @real_html.css("span.inline-title").text.delete("\n")
				#@holiday.duration
				self.location = @real_html.css("p#breadcrumbs").text.delete("\n").delete("\r")
				self.flights = @real_html.css("span.airport").text
				
				# Gets party comp and removes " change"
				self.party_size = @real_html.css("span.party-composition").text.delete("|")[0..-8]
				self.dept_date = @real_html.css("span.itinerary-dates").first.text
				
				self.company = "thomson"
				
				@real_html.css("ul.plist").children.first.search('img').each do |img|
					self.image_url = img['src'].to_s
				end
				
			

				
	    end

	    if self.url.include? "firstchoice"

	    
			@raw_html = HTTParty.get(self.url)
			@real_html = Nokogiri::HTML(@raw_html)		


				self.initial_price = @real_html.css("span.price-pp").text.gsub(/\D/, '').to_i			

				self.hotel_name = @real_html.css("h1").first.text
				#@holiday.duration
				self.location = @real_html.css("p#breadcrumbs").text.delete("\n").delete("\r")
				self.flights = @real_html.css("span.airport").text
				

				# Gets party comp and removes " change"
				self.party_size = @real_html.css(".party-composition").text[0..-7]
				self.dept_date = @real_html.css("span.itinerary-dates").first.text
				
				self.company = "firstchoice"
				
				@real_html.css("ul.plist").children.first.search('img').each do |img|
					self.image_url = img['src'].to_s
				end

	    
	    end
	    
    end
    
    def add_first_history
    
    
		    if self.company == "firstchoice"
    
    			@history = History.new
				@history.holiday_id = self.id
				@history.price = @real_html.css("span.price-pp").text.gsub(/\D/, '').to_i
				@history.save
	
			end
			
			
			if self.company == "thomson"
				@history = History.new
				@history.holiday_id = self.id
				@history.price = @real_html.css("span.price-total").text.gsub(/[^0-9,.]/, "").to_i
				@history.save
	
			end
    
    end
    

    
    

	def must_be_thomson_or_firstchoice		 
	
		valid_urls = ["thomson", "firstchoice"]
	
		errors.add(:base, "At the moment you can only track prices for Thomson and First Choice holidays") unless valid_urls.any? {|mes| self.url.include? mes}
	end



	def must_contain_package_id			
							   
		errors.add(:base, "Must be hotel details page") unless self.url.include? "packageId"
	
	end    														   
    															   
   																   
end
