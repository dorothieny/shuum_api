require "test_helper"

class SoundcardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @soundcard = soundcards(:one)
  end

  test "should get index" do
    get soundcards_url, as: :json
    assert_response :success
  end

  test "should create soundcard" do
    assert_difference("Soundcard.count") do
      post soundcards_url, params: { soundcard: { audiofile: @soundcard.audiofile, description: @soundcard.description, image: @soundcard.image, location: @soundcard.location, name: @soundcard.name } }, as: :json
    end

    assert_response :created
  end

  test "should show soundcard" do
    get soundcard_url(@soundcard), as: :json
    assert_response :success
  end

  test "should update soundcard" do
    patch soundcard_url(@soundcard), params: { soundcard: { audiofile: @soundcard.audiofile, description: @soundcard.description, image: @soundcard.image, location: @soundcard.location, name: @soundcard.name } }, as: :json
    assert_response :success
  end

  test "should destroy soundcard" do
    assert_difference("Soundcard.count", -1) do
      delete soundcard_url(@soundcard), as: :json
    end

    assert_response :no_content
  end
end
