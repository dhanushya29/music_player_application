class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  # before_action :set_imageable
  # GET /albums or /albums.json
  def index
      #@albums=Album.all 
      if params[:q].present?
        @albums=Album.where("title LIKE?","%#{params[:q]}%")
        if artist_signed_in?
          @artists=Artist.all 
        end 
      else
      @albums=Album.all 
      if artist_signed_in?
        @artists=Artist.all 
      end 
     end 
  end

  # GET /albums/1 or /albums/1.json
  #showing artist's album
  def show
    @songs = @album.songs
    @image=@album.image
   # @artist=params[:artist][:artist_id]
  end

  # GET /albums/new
  def new
    @album = Album.new
    @artist=params[:artist_id] #undefined method error
  end
  

  def insert
    @artist=Artist.find(params[:artist_id])
    @song =Song.find(params[:song_id])
    if @artist.album.present?
      @artist.album.songs << @song
    else
      @album=@artist.create_album(artist_id: params[:artist_id])
      @artist.album.songs << @song 
    end

    flash[:notice] = "#{@song.title} added to album"

    redirect_to songs_path
  end 


  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    if artist_signed_in?
      @artist=current_artist
      @album=@artist.albums.create(album_params)
      if @album.save 
        redirect_to albums_path
      else 
        render 'new'
      end 
    else 
      @playlist=current_user.playlist
      @album=Album.find(params[:album_id])
      redirect_to playlist_path(current_user)
    end
    
  end 


    

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    if @album.update(album_params)
      redirect_to albums_path
    else
      render 'new'
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    
    @album.destroy
    redirect_to albums_path
    
  end

  
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end
    
    private
    
    # def set_imageable
    #   @imageable = Album.friendly.find(params[:album_id])

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:title, :artist_id, :description, :language ,:image_url)
    end
end