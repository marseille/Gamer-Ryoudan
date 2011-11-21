require 'test_helper'
require 'mocha'

class AboutControllerTest <  ActionController::TestCase
  
	test 'index_loads_properly' do		
		get :index
		assert_response :success		
	end
end
