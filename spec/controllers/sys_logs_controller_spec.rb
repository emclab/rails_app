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
      #session[:user_positions] = ['sales']
      get 'index'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")     
    end
    
    it "should success for admin" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'admin')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'sys_logs')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
      u = FactoryGirl.create(:user)
      ul = FactoryGirl.create(:user_level, :user_id => u.id, :position => 'admin')  
      session[:user_privilege] = UserPrivilege.new(u.id)
      slog = FactoryGirl.create(:sys_log)
      get 'index'     
      assigns(:sys_logs).should eq([slog])
      response.should be_success
    end
    
    it "should success for ceo" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'sys_logs')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
      u = FactoryGirl.create(:user)
      ul = FactoryGirl.create(:user_level, :user_id => u.id, :position => 'ceo')      
      session[:user_privilege] = UserPrivilege.new(u.id)      
      slog = FactoryGirl.create(:sys_log)
      get 'index'
      assigns(:sys_logs).should eq([slog])
      response.should be_success
    end    
  end
  
end
