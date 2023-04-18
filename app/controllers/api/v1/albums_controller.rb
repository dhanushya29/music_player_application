class Api::V1::AlbumsController < Api::V1::ApiController
  before_action :set_album, only: %i[ show edit update destroy ]
  #before_action :set_artist,only: [:create]
  # before_action :artist_or_user,only: %i[update destroy edit]
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


  def new
    album = Album.new
    render json: {album:album}
  end
  
  

  def edit
  end

  def create
    if current_artist.is_a? Artist
      album=current_artist.albums.create(title: params[:album][:title],description: params[:album][:description],language: params[:album][:language])
      if album.save 
        render json: {album:album}
      else 
        render json: {message:"Album not created"}
      end 
    else 
      render json: {message:"Album not created"},status: :unauthorized
    end
  end 


    
  def update
    if current_artist.is_a? Artist
    if @album.update(album_params)
      render json: {album:@album}
    else
      render json: {message:"Album not updated"}
    end
  else
    render json:{message:"unauthorized"},status: :unauthorized
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
