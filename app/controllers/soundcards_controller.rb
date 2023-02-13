class SoundcardsController < ApplicationController
  before_action :set_soundcard, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: [:index, :show, :newest, :popular]

  # GET /soundcards
  def index
  @soundcards = Soundcard.all
  filtering_params(params).each do |key, value|
    @soundcards = @soundcards.public_send("filter_by_#{key}", value) if value.present?
  end

   @soundcards = @soundcards.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end

    render json: @soundcards
  end

  # GET /soundcards/1
  def show
    @author = User.where(id: @soundcard.user_id)
    render json: {likes: @soundcard.likes, tags: @soundcard.tags, soundcard: @soundcard, author: @author.first.name}, status: :ok
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
    @current_week = Soundcard.where("created_at >= ?", Date.today - 7).map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end
    render json: @current_week
  end

  def popular
    @popular = Soundcard.all.select {|soundcard| soundcard.likes.count >= 1}
    @popular = @popular.map do |soundcard|
      soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
  end
    render json: @popular
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
