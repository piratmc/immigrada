require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get n400" do
    get :n400
    assert_response :success
  end

end
