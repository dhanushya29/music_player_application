class SearchController < ApplicationController
	def index
		@albums=Album.where("title LIKE ?","%" + params[:q] + "%")
        @songs=Song.where("title LIKE ?","%" + params[:q] + "%")
	end 
end