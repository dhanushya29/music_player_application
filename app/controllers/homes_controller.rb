class HomesController < ApplicationController
	def index
		@albums=Album.all 
	end 
end
