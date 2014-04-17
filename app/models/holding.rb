class Holding < ActiveRecord::Base
	validates :email, presence: true
end
