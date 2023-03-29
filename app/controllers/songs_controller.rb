class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]

  # GET /songs or /songs.json
  def index
    if params[:q].present?
      @songs=Song.where("title LIKE?","%#{params[:q]}%")
      if user_signed_in?
        @users=User.all
      end
    else
      @songs=Song.all
      if user_signed_in?
        @users=User.all 
      end
    end
  end

  # GET /songs/1 or /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
    @artist=params[:artist_id]
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs or /songs.json
  def create
        @artist = params[:artist_id]
        @song = @artist.create_song(title: params[:song][:title],lyrics: params[:song][:lyrics],duration: params[:song][:duration])
         
        if @song.save
          redirect_to songs_path
        else
           render 'new'
        # else
        #     @cart=current_user.cart
        #     @product=Product.find(params[:product_id])
        #     @product.update(req_quantity:(params[:product][:quantity]))
        #     redirect_to cart_path(current_user)

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
