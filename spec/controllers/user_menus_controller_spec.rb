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
      #session[:user_type] = 'employee'
      #session[:user_positions] = ['admin']
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'admin')
      table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'sys_logs')
      right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
      ul = FactoryGirl.create(:user_level, :position => 'admin')
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_id] = u.id
      session[:user_privilege] = UserPrivilege.new(u.id)     
      get 'index'
      response.should be_success
    end
    
  end

end

