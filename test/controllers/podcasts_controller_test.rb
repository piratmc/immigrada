require 'test_helper'

class PodcastsControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
