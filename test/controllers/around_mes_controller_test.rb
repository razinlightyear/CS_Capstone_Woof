require 'test_helper'

class AroundMeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get around_me_index_url
    assert_response :success
  end

  test "should get show" do
    get around_me_show_url
    assert_response :success
  end

end
