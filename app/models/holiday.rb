class Holiday < ActiveRecord::Base

	has_many :histories
	belongs_to :user
	
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
				self.last_emailed = self.initial_price
				
				
				# Duration by class name
				
				duration = @real_html.css("li.duration").first.child.attr('class')
				
				case duration
					when 'd1'
						self.duration = "1 night"
					when 'd2'
						self.duration = "2 nights"
					when 'd3'
						self.duration = "3 nights"
					when 'd4'
						self.duration = "4 nights"
					when 'd5'
						self.duration = "5 nights"
					when 'd6'
						self.duration = "6 nights"
					when 'd7'
						self.duration = "7 nights"
					when 'd8'
						self.duration = "8 nights"
					when 'd9'
						self.duration = "9 nights"
					when 'd10'
						self.duration = "10 nights"
					when 'd11'
						self.duration = "11 nights"
					when 'd12'
						self.duration = "12 nights"
					when 'd13'
						self.duration = "13 nights"
					when 'd14'
						self.duration = "14 nights"
					when 'd15'
						self.duration = "15 nights"
					when 'd16'
						self.duration = "16 nights"
					when 'd17'
						self.duration = "17 nights"
					when 'd18'
						self.duration = "18 nights"
					when 'd19'
						self.duration = "19 nights"
					when 'd20'
						self.duration = "20 nights"
					when 'd21'
						self.duration = "21 nights"
					when 'd22'
						self.duration = "22 nights"
					when 'd23'
						self.duration = "23 nights"
					when 'd24'
						self.duration = "24 nights"
					when 'd25'
						self.duration = "25 nights"
					when 'd26'
						self.duration = "26 nights"
					when 'd27'
						self.duration = "27 nights"
					end 

				
				
				
				
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
				self.last_emailed = self.initial_price
				
				@real_html.css("ul.plist").children.first.search('img').each do |img|
					self.image_url = img['src'].to_s
				end
				# Duration by class name
				
				duration = @real_html.css("li.duration").first.child.attr('class')
				
				case duration
					when 'd1'
						self.duration = "1 night"
					when 'd2'
						self.duration = "2 nights"
					when 'd3'
						self.duration = "3 nights"
					when 'd4'
						self.duration = "4 nights"
					when 'd5'
						self.duration = "5 nights"
					when 'd6'
						self.duration = "6 nights"
					when 'd7'
						self.duration = "7 nights"
					when 'd8'
						self.duration = "8 nights"
					when 'd9'
						self.duration = "9 nights"
					when 'd10'
						self.duration = "10 nights"
					when 'd11'
						self.duration = "11 nights"
					when 'd12'
						self.duration = "12 nights"
					when 'd13'
						self.duration = "13 nights"
					when 'd14'
						self.duration = "14 nights"
					when 'd15'
						self.duration = "15 nights"
					when 'd16'
						self.duration = "16 nights"
					when 'd17'
						self.duration = "17 nights"
					when 'd18'
						self.duration = "18 nights"
					when 'd19'
						self.duration = "19 nights"
					when 'd20'
						self.duration = "20 nights"
					when 'd21'
						self.duration = "21 nights"
					when 'd22'
						self.duration = "22 nights"
					when 'd23'
						self.duration = "23 nights"
					when 'd24'
						self.duration = "24 nights"
					when 'd25'
						self.duration = "25 nights"
					when 'd26'
						self.duration = "26 nights"
					when 'd27'
						self.duration = "27 nights"
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
							   
		errors.add(:base, "This must be the 'more details' page, click the 'what do I need to do' link below for more information") unless self.url.include? "packageId"
	
	end    														   
    															   
   																   
end
