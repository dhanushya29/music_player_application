class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  # before_action :authenticate_artist!
  def index
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

  def show
    @songs = @album.songs
    @image=@album.image
  end

  def new
    @album = Album.new
    @artist=params[:artist_id] 
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
         image =  @album.build_image
         image.image_url = @album.image_url
         image.save
        redirect_to albums_path
      else 
        render 'new'
      end  
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
    # @album.songs.destroy_all

    @album.destroy
    redirect_to albums_path
    
  end

  
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end
    
    private
    
  
    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:title, :artist_id, :description, :language ,:image_url)
    end
end