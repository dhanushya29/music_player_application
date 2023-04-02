class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]

  # GET /songs or /songs.json
  def index
    if params[:q].present?
      @songs=Song.where("title LIKE?","%#{params[:q]}%")
      if artist_signed_in?
        @artists=Artist.all
      end
    else
      @songs=Song.all
      if artist_signed_in?
        @artists=Artist.all 
      end
    end
  end

  # GET /songs/1 or /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
    @album=params[:album_id]
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs or /songs.json
  def create
        if artist_signed_in?
          @artist=current_artist
          @song=@artist.songs.create(title: params[:song][:title],duration: params[:song][:duration],lyrics: params[:song][:lyrics])
          if @song.save
            redirect_to songs_path
          else 
            render 'new'
          end 
        else 
          @playlist=current_user.playlist
          @song=Song.find(params[:song_id])
          redirect_to playlist_path(current_user)
        end 
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to songs_path, notice: "Song was successfully updated." }
        format.json { render :show, status: :ok, location: @song }
      else
        render 'new'
      end
    end
  end

  # DELETE /songs/1 or /songs/1.json
  def destroy
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_path, notice: "Song was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.require(:song).permit(:title, :album_id, :duration, :lyrics)
    end
end
