class Api::V1::AlbumsController < Api::V1::ApiController
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :doorkeeper_authorize!

  def index
    if current_artist.is_a? Artist
      albums=current_artist.albums
    else
      albums=Album.all 
    end 
      render json: {Albums:albums}
  end

  
  def show
    render json: {message:"Showing album",album:@album,songs:@album.songs}
  end


  def edit
  end

  def create
    if current_artist.is_a? Artist
      @album = Album.new(album_params)
      @album.artist_id=current_artist.id
      if @album.save 
        render json: {message: "Album #{@album.id} is created successfully"},status: 201
      else 
        render json: {message:"Album not created"}
      end 
    else 
      render json: {error:"You are not allowed to create"},status: 403
    end
  end 


    
  def update
    if current_artist.is_a? Artist
      if @album.artist_id == current_artist.id
        if @album.update(album_params)
          render json: {message: "Album #{@album.id} is updated successfully"}
        else
          render json: {message:"Album not updated"}
        end
      else
        render json:{error:"unauthorized"},status: :unauthorized
      end
    else
      render json: {error:"You are not allowed to updatee"},status: 403
    end
  end

  
  def destroy
    if current_artist.is_a? Artist
      if @album.artist_id == current_artist.id
        if @album.destroy
          render json: {message: "Album #{@album.id} is deleted successfully"},status: 204
        else
          render json: {message:"Album not deleted"}
        end
      else
         render json:{error:"unauthorized"},status: :unauthorized
      end
    else
      render json: {message:"You are not allowed to delete"},status: 403
    end
  end

  
    
    def set_album
      @album = Album.find(params[:id])
    rescue
      render json: "Album not found",status: :not_found
    end
    
    def artist_or_user 
      if current_user.present?
        render json: "User cannot create/ modify / delete albums"
      end 
    end 

    private
    
    def album_params
      params.require(:album).permit(:title,:description, :language)
    end
end
