require 'test_helper'

class AroundMesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get around_mes_index_url
    assert_response :success
  end

  test "should get show" do
    get around_mes_show_url
    assert_response :success
  end

end
