class SoundcardsController < ApplicationController
  before_action :set_soundcard, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: [:index, :show, :newest, :popular, :striked, :random, :popshort, :newshort]

  # GET /soundcards
  def index
  @soundcards = Soundcard.all
  filtering_params(params).each do |key, value|
    @soundcards = @soundcards.public_send("filter_by_#{key}", value) if value.present?
  end
  @soundcards = @soundcards.select {|soundcard| soundcard.strikes.count <= 2}
  @soundcardstest = Kaminari.paginate_array(@soundcards).page(params[:page]).per(15)
  
   @soundcards = @soundcardstest.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end

    render json: @soundcards
  end

  # GET /soundcards/1
  def show
    @author = User.where(id: @soundcard.user_id)
    render json: {likes: @soundcard.likes, tags: @soundcard.tags, soundcard: @soundcard, author: @author.first.name, strikes: @soundcard.strikes}, status: :ok
  end

  # POST /soundcards
  def create
    @soundcard = Soundcard.new(soundcard_params.except(:tags).merge(user_id: current_user.id))
    create_or_delete_soundcards_tags(@soundcard, params[:soundcard][:tags])
    if @soundcard.save
      render json: @soundcard, status: :created, location: @soundcard
    else
      render json: @soundcard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /soundcards/1
  def update
    create_or_delete_soundcards_tags(@soundcard, params[:soundcard][:tags])
    if @soundcard.update(soundcard_params.except(:tags))
      render json: @soundcard
    else
      render json: @soundcard.errors, status: :unprocessable_entity
    end
  end

  # DELETE /soundcards/1
  def destroy
    @soundcard.destroy
  end

  def newest
    @middleres = Soundcard.all.select{|soundcard| soundcard.strikes.count <= 2 && soundcard.created_at >= Date.today - 7}
    @current = Kaminari.paginate_array(@middleres).page(params[:page]).per(15)
    @current_week = @current.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end
    render json: @current_week
  end

  def popular
    @popular = Soundcard.all.select {|soundcard| soundcard.likes.count >= 1 && soundcard.strikes.count <= 2 }
    @current = Kaminari.paginate_array(@popular).page(params[:page]).per(15)
    @popular = @current.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end
    render json: @popular
  end

  def newshort
    @middleres = Soundcard.all.select{|soundcard| soundcard.strikes.count <= 2 && soundcard.created_at >= Date.today - 7}
    @current_week = @middleres.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end
    render json: @current_week.first(3)
  end

  def popshort
    @popular = Soundcard.all.select {|soundcard| soundcard.likes.count >= 1 && soundcard.strikes.count <= 2 }
    @popular = @popular.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end
    render json: @popular.first(3)
  end



  def random
    @random_sound_count = Soundcard.all.select {|soundcard| soundcard.strikes.count <= 2}
    @random_sound = Soundcard.offset(rand(@random_sound_count.length)).first

    @author = User.where(id: @random_sound.user_id)
    render json: {likes: @random_sound.likes, tags: @random_sound.tags, soundcard: @random_sound, author: @author.first.name}, status: :ok
  end


  def striked
    @striked = Soundcard.all.select {|soundcard| soundcard.strikes.count >= 1}
    @striked = @striked.map do |soundcard|
      soundcard.as_json.merge({:strikes => soundcard.strikes, :tags => soundcard.tags})
  end
    render json: @striked

    # if current_user.isadmin?
    #   render json: @striked
    # else
    #   render json: {message: "You can't get strikes as you are not an admin"} 
    # end

  end

  private

  def create_or_delete_soundcards_tags(soundcard, tags)
    soundcard.taggables.destroy_all
    if tags 
    tags = tags.strip.split(',')
    tags.each do |tag|
      soundcard.tags << Tag.find_or_create_by(tagname: tag)
    end
  end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_soundcard
      @soundcard = Soundcard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def soundcard_params
      params.require(:soundcard).permit(:name, :description, :audiofile, :image, :location, :tags)
    end

    def filtering_params(params)
      params.slice(:starts_with, :location, :multiple)
    end

end
