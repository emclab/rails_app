# encoding: utf-8
require 'spec_helper'

describe UsersController do

  render_views
   
  context "test before filters" do
    describe "before filter" do
      it "should reject by before_filter require_signin if not signed in" do
        ul = FactoryGirl.create(:user_level)
        u = FactoryGirl.create(:user, :user_levels => [ul])
        get 'index'
        response.should_not have_selector('title', :content => "用户名单")
        response.code.should_not eq('200')
        assigns(:users).should_not eq([u])        
      end    
      
      it "should reject by before_filter require_signin and require_admin if not signed in" do
        user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
        table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'sys_logs')
        right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
        ul = FactoryGirl.create(:user_level, :position => 'ceo')
        u = FactoryGirl.create(:user, :user_levels => [ul])
        session[:user_privilege] = UserPrivilege.new(u.id)          
        get 'index'
        response.should_not have_selector('title', :content => "用户名单")
        response.code.should_not eq(200)        
        assigns(:users).should_not eq([u])
      end    
                  
    end  
  end
  
  context "User controller" do
    before(:each) do
    #the following recognizes that there is a before filter without execution of it.
      controller.should_receive(:require_signin)
        user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo')
        table_right = FactoryGirl.create(:sys_action_on_table, :action => 'index', :table_name => 'users')
        right = FactoryGirl.create(:sys_user_right, :sys_user_group_id => user_group.id, :sys_action_on_table_id => table_right.id, :matching_column_name => nil)
        ul = FactoryGirl.create(:user_level, :user_id => 1, :position => 'sales')
        @uu =  FactoryGirl.create(:user, :user_levels => [ul])
        ul1 = FactoryGirl.create(:user_level, :user_id => 2, :position => 'ceo')
        @u = FactoryGirl.create(:user, :user_levels => [ul1], :last_updated_by_id => @uu.id, :email => "aa@example.com")
        session[:user_privilege] = UserPrivilege.new(@u.id)
    end
         
    describe "'index'" do
      it "returns http success" do 

        get 'index'
        response.should be_success
        assigns(:users).should eq([@u, @uu])
      end
    end

    describe "'show'" do
      it "returns http success" do
        get 'show', :id => @u.id
        response.should be_success
      end
    end

    describe "'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
    end

    describe "'create'" do
    
      it "should render new if data is missing the user position" do
        u1 = FactoryGirl.attributes_for(:user, :user_levels_attributes => { '1' => {:position => ''}}) 
        get 'create', :user => u1
        response.should render_template('new')
      end
    
      it "returns http success with a valid input and increase the user count by 1" do
        session[:user_id] = @u.id
        u1 = FactoryGirl.attributes_for(:user, :user_levels_attributes => { '1' => {:position => 'ceo'}})
        lambda do
          get 'create', :user => u1
          response.should redirect_to URI.escape("/view_handler?index=0&msg=用户已保存！")
        end.should change(User, :count).by(1)
      end
    
      it "returns http success with a valid user level input and increase the user level count by 1" do
        session[:user_id] = @u.id
        u1 = FactoryGirl.attributes_for(:user, :user_levels_attributes => [ {:position => 'admin'}])
        lambda do
          get 'create', :user => u1
          response.should redirect_to URI.escape("/view_handler?index=0&msg=用户已保存！")
        end.should change(UserLevel, :count).by(1)
      end    
    end

    describe "'edit'" do
      it "returns http success with a valid user" do
        ull = FactoryGirl.create(:user_level)
        u1 = FactoryGirl.create(:user, :email => 'b@example11.com', :user_levels => [ull])
        get 'edit', :id => u1.id
        response.should be_success
      end
    end

    describe "'update'" do
      it "returns success with a valid update" do    
        session[:user_id] = @u.id
        get 'update', :id => @u.id, :user => {:name => 'a new name'}
        response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
      end
    
      it "would be OK to update the user level" do
        session[:user_id] = @u.id
        get 'update', :id => @u.id, :user => {:user_levels_attributes => [{:position => 'a new name'}]}
        response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
      end    
    end
  end
end
