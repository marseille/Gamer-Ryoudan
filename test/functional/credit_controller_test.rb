require 'test_helper'

class CreditControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "index should work" do
    get :index
    assert_response :success
  end
end
