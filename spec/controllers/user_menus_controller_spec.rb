require 'spec_helper'

describe UserMenusController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
  end
  
  render_views
  
  describe "GET 'index'" do
    it "returns http success" do
      #controller.should_receive(:require_signin)
      session[:user_type] = 'employee'
      session[:user_positions] = ['admin']
      get 'index'
      response.should be_success
    end
    
  end

end

