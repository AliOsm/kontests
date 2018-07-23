require 'test_helper'

class JoinsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get joins_index_url
    assert_response :success
  end

  test "should get create" do
    get joins_create_url
    assert_response :success
  end

end
