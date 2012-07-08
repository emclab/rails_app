# encoding: utf-8
require 'spec_helper'

describe "LoginLinks" do
  describe "GET /login_links" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/signin'
      response.status.should be(200)
    end
    
    it "should have title Login" do
      get '/'
      response.should have_selector('title', :content => 'Login')
    end
    
    it "should login in with right user name and password" do
      #ul = FactoryGirl.build(:user_level, :position => 'admin')
      user = FactoryGirl.create(:user, :login => 'tester1', :password => 'password', 
                                :password_confirmation => 'password', 
                                :user_levels => [FactoryGirl.build(:user_level, :position => 'sales')] )
      lambda do
        visit '/'
        fill_in "login", :with => 'tester1'
        fill_in "password", :with => 'password'
        click_button
        response.should render_template("user_menus/index")
        #response.should have_selector('title', :content => "EMC Lab")
      end.should change(Session, :count).by(1)
    end
    
  end
  
  describe "user page" do
    
    before(:each) do
      user = FactoryGirl.create(:user, :login => 'test@example.com', :password => 'password', :password_confirmation => 'password')
      visit '/'
      fill_in "login", :with => 'test@example.com'
      fill_in "password", :with => 'password'
      click_button   
    end

    it "should render new user page" do
      visit new_user_path
      response.should have_selector("h1", :content => "输入用户")
    end  

    it "should have email field" do
      visit new_user_path
      response.should have_selector("input[name='user[login]'][type='text']")
    end
    
    it "should have password field" do
      visit new_user_path
      response.should have_selector("input[name='user[password]'][type='password']")
    end  
                  
    it "should have new user link" do
      visit users_path
      response.should have_selector("a", :href => SUBURI + "/view_handler?index=1&url=#{new_user_path}", :content => "创建新用户")
    end
       
  end
end
