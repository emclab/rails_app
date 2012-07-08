# encoding: utf-8
require 'spec_helper'
require 'application_controller.rb'
require 'sessions_helper.rb'

describe SessionsController do
  
  render_views
  
  describe "'new" do
    it "should be success for new" do
      get 'new'
      response.should be_success
    end  
  end
  
  describe "GET 'create'" do
    it "returns http success" do
      u = FactoryGirl.create(:user)
      get 'create', :user => {:login => u.login, :password => u.password}
      response.should be_success
    end
    
    it "should display error for wrong login/password" do
      u = FactoryGirl.create(:user)
      get 'create', :user => {:login => u.login, :password => u.password + 'ab'}
      flash.now[:error].should eq "登录名/密码错误！"
      response.should render_template('new')
    end
    
    it "should reject nil login" do
      u = FactoryGirl.create(:user)
      get 'create', :user => {:login => nil, :password => u.password }
      flash.now[:error].should eq "登录名/密码错误！"
      response.should render_template('new')
    end  
    
    it "should reject nil password" do
      u = FactoryGirl.create(:user)
      get 'create', :user => {:login => u.login, :password => nil}
      flash.now[:error].should eq "登录名/密码错误！"
      response.should render_template('new')
    end    
          
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      u = FactoryGirl.create(:user)
      get 'destroy', :user => {:login => u.login, :password => u.password}
      flash.now[:notice].should eq "退出了!"
      response.should redirect_to(signin_path)
    end
  end

end