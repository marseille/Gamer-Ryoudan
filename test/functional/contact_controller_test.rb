require 'test_helper'
require "authlogic/test_case"


class ContactControllerTest < ActionController::TestCase
  
	setup :activate_authlogic	
	
  test 'index_should_load_properly' do
    get :index
    delete flash[:notice] if flash[:notice]
    assert_nil flash[:notice]
    assert_response :success	
  end
	
  test 'email feedback can be sent when logged in' do
    num_deliveries = ActionMailer::Base.deliveries.size		
    u = User.create({"login" => "login1", "password"=>"123456", "password_confirmation"=>"123456", "email" => "1@1.aol.com"})						
    post :feedback
    assert_not_nil assigns["current_user"]
    assert_equal flash[:notice], "Email sent!"		
    assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size		
  end
	
  test 'email feedback can be sent when not logged in' do
    num_deliveries = ActionMailer::Base.deliveries.size				
    post :feedback									
    assert_equal flash[:notice], "Email sent!"		
    assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size		
  end
end
