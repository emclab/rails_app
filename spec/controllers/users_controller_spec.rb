# encoding: utf-8
require 'spec_helper'

describe UsersController do

  render_views
   
  context "test before filters" do
    describe "before filter" do
      it "should reject by before_filter require_signin and require_admin if not signed in" do
        session[:admin] = false
        session[:employee] = true
        u = FactoryGirl.create(:user)     
        get 'index'
        response.should_not have_selector('title', :content => "用户名单")
        response.code.should_not eq('200')
        assigns(:users).should_not eq([u])        
      end    
      
      it "should reject by before_filter require_signin and require_admin if not signed in" do
        session[:admin] = true
        session[:employee] = false
        u = FactoryGirl.create(:user)     
        get 'index'
        response.should_not have_selector('title', :content => "用户名单")
        response.code.should_not eq(200)        
        assigns(:users).should_not eq([u])
      end    

      it "should reject by before_filter require_signin and require_admin if not signed in" do
        u = FactoryGirl.create(:user)     
        get 'index'
        response.should_not have_selector('title', :content => "用户名单")
        response.code.should_not eq('200')        
        assigns(:users).should_not eq([u])
      end    
                  
    end  
  end
  
  context "User controller" do
    before(:each) do
    #the following recognizes that there is a before filter without execution of it.
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      controller.should_receive(:require_admin)
    end
         
    describe "'index'" do
      it "returns http success" do 
        u = FactoryGirl.create(:user)  
        #ul = FactoryGirl.create(:user_level, :user_id => u.id)  
        get 'index'
        response.should be_success
        assigns(:users).should eq([u])
      end
    end

    describe "'show'" do
      it "returns http success" do
        u0 = FactoryGirl.create(:user, :email => nil)
        u = FactoryGirl.create(:user, :last_updated_by_id => u0.id)
        ul = FactoryGirl.create(:user_level, :user_id => u.id)
        get 'show', :id => u.id
        response.should be_success
      end
    end

    describe "'new'" do
      it "returns http success" do
        u = FactoryGirl.build(:user)
        ul = FactoryGirl.build(:user_level, :user_id => u.id)
        get 'new'
        response.should be_success
      end
    end

    describe "'create'" do
    
      it "should render new if data is missing the user position" do
        u = FactoryGirl.attributes_for(:user, :user_levels_attributes => { '1' => {:position => ''}}) 
        get 'create', :user => u
        response.should render_template('new')
      end
    
      it "returns http success with a valid input and increase the user count by 1" do
        session[:user_id] = 1
        #u = FactoryGirl.attributes_for(:user, :user_levels_attributes => { '1' => {:position => 'ceo'}})
        u = FactoryGirl.attributes_for(:user, :user_levels_attributes => [{:position => 'ceo'}])
        #u = FactoryGirl.attributes_for(:user)
        lambda do
          get 'create', :user => u
          response.should redirect_to URI.escape("/view_handler?index=0&msg=用户已保存！")
        end.should change(User, :count).by(1)
      end
    
      it "returns http success with a valid user level input and increase the user level count by 1" do
        session[:user_id] = 1
        u = FactoryGirl.attributes_for(:user, :user_levels_attributes => [ {:position => 'admin'}])
        #u = FactoryGirl.attributes_for(:user)
        lambda do
          get 'create', :user => u
          response.should redirect_to URI.escape("/view_handler?index=0&msg=用户已保存！")
        end.should change(UserLevel, :count).by(1)
      end    
    end

    describe "'edit'" do
      it "returns http success with a valid user" do
        u = FactoryGirl.create(:user)
        get 'edit', :id => u.id
        response.should be_success
      end
    end

    describe "'update'" do
       it "returns success with a valid update" do
       u = FactoryGirl.create(:user)      
        ul = FactoryGirl.create(:user_level, :user_id => u.id)
        session[:user_id] = 1
        get 'update', :id => u.id, :user => {:name => 'a new name'}
        response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
      end
    
      it "would be OK to update the user level" do
        u = FactoryGirl.create(:user)      
        ul = FactoryGirl.create(:user_level, :user_id => u.id)
        session[:user_id] = u.id
        get 'update', :id => u.id, :user => {:user_levels_attributes => [{:position => 'a new name'}]}
        response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
      end    
    end
  end
end
