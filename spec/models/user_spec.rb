# encoding: utf-8
require 'spec_helper'

describe User do
  
  it "should create a new user" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :user_levels => [ul])
    u.should be_valid
  end
  
  it "should reject nil login" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :login => nil, :user_levels => [ul])
    u.should_not be_valid
  end
  
  it "should reject nil status" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :status => nil, :user_levels => [ul])
    u.should_not be_valid
  end
  
  it "should reject nil name" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :name => nil, :user_levels => [ul])
    u.should_not be_valid
  end
  
  it "should reject nil password" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :password => nil, :user_levels => [ul])
    u.should_not be_valid
  end
  
  it "should reject -0- last_updated_by_id" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :last_updated_by_id => 0, :user_levels => [ul])
    u.should_not be_valid
  end
  

end

