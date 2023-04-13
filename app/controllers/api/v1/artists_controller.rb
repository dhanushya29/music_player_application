class Api::V1::ArtistsController < Api::V1::ApiController
  before_action :set_artist,only: [:show]
  #before_action :set_album,only: [:total]
  before_action :doorkeeper_authorize!
  def index
    artists=Artist.all 
    render json: {artists:artists},status: :ok
  end

  def new 
    artist=Artist.new
    render json: {artist: artist}
  end 


  def show
    # if params[:id].to_i != current_artist.id 
    #   render json: {error: "You're not authrised to do that"},status: :forbidden
    # end
    render json: {artist: @artist}
  end

  def create
    artist=Artist.new(artist_params)
    if artist.save
      render json: {artist: artist}
    else 
      render json: {message:"artistnot created"},status: 425
    end
  end
  
   
  def set_artist
    @artist=Artist.find(params[:id])
    rescue
      render json: "Artist not found",status: :not_found
  end 
  
  

  def artist_params
    params.permit(:name,:email,:region,:password)
  end 
end
