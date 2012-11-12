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
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'ceo')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = UserPrivilege.new(u.id)    
      session[:user_privilege].action_rights.should eq([['index','sys_logs']])      
    end

    it "should return correct user action with matching_column_name" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'users')
      right1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => "last_updated_by_id")
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => "id")
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'ceo')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = UserPrivilege.new(u.id)          
      session[:user_privilege].has_action_right?('index', 'users', nil, u).should be_true
    end

    it "should return true with correct accessible column name" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'users')
      right1 = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :accessible_column_name => "customer_name")
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :accessible_column_name => "user_name")
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'ceo')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = UserPrivilege.new(u.id)
      session[:user_privilege].has_action_right?('index', 'users', "user_name", nil).should be_true
    end

    it "should return false if accessible column name does not match" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'users')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :accessible_column_name => "user_name")
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'ceo')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = UserPrivilege.new(u.id)
      session[:user_privilege].has_action_right?('index', 'users', "user_password", nil).should be_false
    end
        
    it "should return manager group" do
      ul = FactoryGirl.build(:user_level, :position => 'sales', :manager => 'sales_manager', :user_id => 1)
      u = FactoryGirl.create(:user, :user_levels => [ul])
      ul1 = FactoryGirl.create(:user_level, :user_id => 2, :position => 'sales_manager', :manager => 'corp_head')
      user1 = FactoryGirl.create(:user, :user_levels => [ul1], :email => "b@example1.com")
      ul2 = FactoryGirl.create(:user_level, :user_id => 3, :position => 'corp_head', :manager => 'ceo')
      user2 = FactoryGirl.create(:user, :user_levels => [ul2], :email => "b@example111.com")
      session[:user_privilege] = UserPrivilege.new(u.id)    
      session[:user_privilege].manager_groups.include?('ceo').should be_true 
      session[:user_privilege].manager_groups.include?('sales_manager').should be_true 
      session[:user_privilege].manager_groups.include?('corp_head').should be_true          
    end
    
    it "should return sub groups (member)" do
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'sales', :manager => 'sales_manager')
      u = FactoryGirl.create(:user, :user_levels => [ul] )
      ul1 = FactoryGirl.create(:user_level, :user_id => 2, :position => 'sales_manager', :manager => 'corp_head')
      user1 = FactoryGirl.create(:user, :user_levels => [ul1], :email => "b@example1.com")
      ul2 = FactoryGirl.create(:user_level, :user_id => 3, :position => 'corp_head', :manager => 'ceo')
      user2 = FactoryGirl.create(:user, :user_levels => [ul2], :email => "b@example111.com")
      ul3 = FactoryGirl.create(:user_level, :user_id => 4, :position => 'ceo', :manager => nil)
      user3 = FactoryGirl.create(:user, :user_levels => [ul3],  :email => "b@example11122.com")
      session[:user_privilege] = UserPrivilege.new(user3.id)   
      session[:user_privilege].sub_groups.include?('sales').should be_true 
      session[:user_privilege].sub_groups.include?('sales_manager').should be_true 
      session[:user_privilege].sub_groups.include?('corp_head').should be_true
    end

    it "should return the right module_group_name for a given user/user_group" do
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'sales')
      u = FactoryGirl.create(:user, :user_levels => [ul] )
      group = FactoryGirl.create(:sys_user_group, :user_group_name => 'sales')
      mod = FactoryGirl.create(:sys_module, :module_name => 'bizTravels', :module_group_name => 'approver')
      module_mapping = FactoryGirl.create(:sys_module_mapping, :sys_module_id => mod.id, :sys_user_group_id => group.id)
      session[:user_id] = u.id
      session[:user_privilege] = UserPrivilege.new(u.id)
      session[:user_privilege].find_user_module_groups('bizTravels').should == ['approver']
    end

  end
  
  describe "login should assign user rights" do
    it "should set session for the user to act on all records in the table" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index_all', :table_name => 'users')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'ceo')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = UserPrivilege.new(u.id)
      controller.assign_user_rights
      session[:index_all_users].should be_true
    end

    it "should set session for the user to act on each column within a record" do
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'users')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :accessible_column_name => 'each_column')
      ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'ceo')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = UserPrivilege.new(u.id)
      controller.assign_user_rights
      session[:index_users_each_column].should be_true
    end
  end
end
