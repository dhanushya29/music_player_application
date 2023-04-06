class Api::V1::AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :set_artist,only: [:create]
  skip_before_action :verify_authenticity_token
  def index
      albums=Album.all 
      render json: {Albums:albums}
  end

  
  def show
    render json: {message:"Showing album",album:@album,songs:@album.songs}
  end


  def new
    album = Album.new
    render json: {album:album}
  end
  
  

  def edit
  end

  def create
      album=@artist.albums.create(title: params[:album][:title],description: params[:album][:description],language: params[:album][:language])
      if album.save 
        render json: {album:album}
      else 
        render json: {message:"Album not created"}
      end
  end 


    
  def update
    if @album.update(album_params)
      render json: {album:@album}
    else
      render json: {message:"Album not updated"}
    end
  end

  
  def destroy
    
    @album.destroy
    render json: {album:@album}
    
  end

  
    
    def set_album
      @album = Album.find(params[:id])
    rescue
      render json: "Album not found",status: :not_found
    end
   
    def set_artist
      @artist=Artist.find(params[:artist_id])
      rescue
      render json: "Artist not found",status: :not_found
    end

    private
    
    def album_params
      params.require(:album).permit(:title, :artist_id, :description, :language)
    end
end
