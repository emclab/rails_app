# encoding: utf-8

require 'spec_helper'

describe ApplicationController do
 
  describe "log method" do
    it "should increase log by one by calling sys_logger" do
      lambda do
        controller.sys_logger("test")
      end.should change(SysLog, :count).by(1)
    end
  end
  
  describe "session_timeout" do
    it "should reset session for expired session (90m)" do
      session[:last_seen] = 100.minutes.ago.utc
      controller.session_timeout()
      controller.should {reset_session}
    end
    
    it "should delete session which is more than 12 hours old" do
      session = FactoryGirl.create(:session, :created_at => 13.hours.ago)
      lambda do
        controller.session_timeout()
        controller.should {Session.sweep}
      end.should change(Session, :count).by(-1)
    end
  end
  
  describe "User Privilege object and grant_access?" do
    it "should return right user action" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'sys_logs')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
      u = FactoryGirl.create(:user)
      ul = FactoryGirl.create(:user_level, :user_id => u.id, :position => 'ceo')      
      session[:user_privilege] = UserPrivilege.new(u.id)    
      session[:user_privilege].action_rights.should eq([['index','sys_logs']])      
    end

    it "should return correct user action with matching_column_name" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'users')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => "id")
      u = FactoryGirl.create(:user)
      ul = FactoryGirl.create(:user_level, :user_id => u.id, :position => 'ceo')   
      session[:user_privilege] = UserPrivilege.new(u.id)          
      session[:user_privilege].has_action_right?('index', 'users', u).should be_true
    end
        
    it "should return manager group" do
      u = FactoryGirl.create(:user)
      ul = FactoryGirl.create(:user_level, :user_id => u.id, :position => 'sales', :manager => 'sales_manager')  
      user1 = FactoryGirl.create(:user, :email => "b@example1.com")
      ul1 = FactoryGirl.create(:user_level, :user_id => user1.id, :position => 'sales_manager', :manager => 'corp_head')   
      user2 = FactoryGirl.create(:user, :email => "b@example111.com")
      ul2 = FactoryGirl.create(:user_level, :user_id => user2.id, :position => 'corp_head', :manager => 'ceo')                 
      session[:user_privilege] = UserPrivilege.new(u.id)    
      session[:user_privilege].manager_groups.include?('ceo').should be_true 
      session[:user_privilege].manager_groups.include?('sales_manager').should be_true 
      session[:user_privilege].manager_groups.include?('corp_head').should be_true          
    end
    
    it "should return sub groups (member)" do
      u = FactoryGirl.create(:user)
      ul = FactoryGirl.create(:user_level, :user_id => u.id, :position => 'sales', :manager => 'sales_manager')    
      user1 = FactoryGirl.create(:user, :email => "b@example1.com")
      ul1 = FactoryGirl.create(:user_level, :user_id => user1.id, :position => 'sales_manager', :manager => 'corp_head') 
      user2 = FactoryGirl.create(:user, :email => "b@example111.com")
      ul2 = FactoryGirl.create(:user_level, :user_id => user2.id, :position => 'corp_head', :manager => 'ceo')  
      user3 = FactoryGirl.create(:user, :email => "b@example11122.com")
      ul3 = FactoryGirl.create(:user_level, :user_id => user3.id, :position => 'ceo', :manager => nil)                  
      session[:user_privilege] = UserPrivilege.new(user3.id)   
      session[:user_privilege].sub_groups.include?('sales').should be_true 
      session[:user_privilege].sub_groups.include?('sales_manager').should be_true 
      session[:user_privilege].sub_groups.include?('corp_head').should be_true      
    end
    
  end
  
  
end
