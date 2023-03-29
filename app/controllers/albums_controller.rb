class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  
  # GET /albums or /albums.json
  def index
      @albums=Album.all 
      # @artists=Artist.all
  end

  # GET /albums/1 or /albums/1.json
  #showing artist's album
  def show
    @artist=Artist.find(params[:artist_id])
    @songs = @album.songs
   # @artist=params[:artist][:artist_id]
  end

  # GET /albums/new
  def new
    @album = Album.new
    # @artist=params[:artist_id] #undefined method error
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
    # @artist = Artist.find(params[:artist_id]) #since not using devise cant use current undefined local variable #now showing record not found
    # @album.=@artist.albums.create(title: params[:album][:title],description: params[:album][:description],language: params[:album][:language])
    
    @album = Album.new(album_params)
    @album.artist = Artist.find(params[:id])



    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_path notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
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
    
    @album.destroy
    redirect_to albums_path
    
  end

  
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:title, :artist_id, :description, :language)
    end
end