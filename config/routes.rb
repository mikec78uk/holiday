HolidaySniper::Application.routes.draw do


	resources :holidays



	root "holidays#index"

end

