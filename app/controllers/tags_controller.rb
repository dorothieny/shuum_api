class TagsController < ApplicationController
  before_action :set_tag, only: %i[ show update destroy ]

  # GET /tags
  def index
    @tags = Tag.all
    filtering_params(params).each do |key, value|
      @tags = @tags.public_send("filter_by_#{key}", value) if value.present?
    end
  
    render json: @tags
  end

  # GET /tags/1
  def show
    @tagged = @tag.taggables
    @tagged = @tagged.map do |soundcard|
      soundcard.as_json.merge({:soundcard => Soundcard.find_by(id: soundcard.soundcard_id), tags: Soundcard.find_by(id: soundcard.soundcard_id).tags })
    end
    render json: {data: @tag, posts: @tagged}
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag, status: :created, location: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.require(:tag).permit(:tagname)
    end

    def filtering_params(params)
      params.slice(:starts_with)
    end
end
