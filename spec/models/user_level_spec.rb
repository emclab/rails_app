require 'spec_helper'

describe UserLevel do
  it "should reject nil position" do
    ul = FactoryGirl.build(:user_level, :position => nil)
    ul.should_not be_valid
  end
end
