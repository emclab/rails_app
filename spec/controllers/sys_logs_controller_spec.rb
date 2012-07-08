# encoding: utf-8
require 'spec_helper'

describe SysLogsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    #controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "should reject for those without right" do
      slog = FactoryGirl.create(:sys_log)
      session[:user_positions] = ['sales']
      session[:user_type] = 'employee'
      get 'index'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")     
    end
    
    it "should success for admin" do
      right = FactoryGirl.create(:sys_user_right, :user_position => 'admin')
      session[:user_positions] = ['admin']
      session[:user_type] = 'employee'
      slog = FactoryGirl.create(:sys_log)
      get 'index'
      response.should be_success
    end
    
    it "should success for ceo" do
      right = FactoryGirl.create(:sys_user_right, :user_position => 'ceo')
      session[:user_positions] = ['ceo']
      session[:user_type] = 'employee'
      slog = FactoryGirl.create(:sys_log)
      get 'index'
      response.should be_success
    end    
  end
  
  describe "sort by user id" do
    it "should success for admin" do
      right = FactoryGirl.create(:sys_user_right, :user_position => 'admin')
      session[:user_positions] = ['admin']
      session[:user_type] = 'employee'
      slog = FactoryGirl.create(:sys_log)
      get 'sort_by_user_id'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{sys_logs_path}")      
    end
  end

  describe "sort by user ip" do
    it "should success for admin" do
      right = FactoryGirl.create(:sys_user_right, :user_position => 'admin')
      session[:user_positions] = ['admin']
      session[:user_type] = 'employee'
      slog = FactoryGirl.create(:sys_log)
      get 'sort_by_ip'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{sys_logs_path}")     
    end
  end
end
