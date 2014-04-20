HolidaySniper::Application.routes.draw do

	# Modified from just :users due to new destination after registration
  	devise_for :users, :controllers => { :registrations => "registrations" }
	resources :holidays
	resources :contacts
	resources :holdings

	resources :contents do
		 member do
		  get 'home'
		 end
	end



  	# Added for statiic pages		
  	get '/cookie_policy', to: 'contents#cookie_policy', as: :cookie_page
  	get '/privacy_policy', to: 'contents#privacy_policy', as: :privacy_page
  	get '/terms_of_service', to: 'contents#terms_of_service', as: :terms_page

  	# For custom error pages

	match "404", :to => "errors#not_found", via: 'get'
	match "422", :to => "errors#unacceptable", via: 'get'
	match "500", :to => "errors#internal_error", via: 'get'
	

	root "contents#home"



end

