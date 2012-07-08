#encoding: utf-8
require 'spec_helper'

describe SysLog do
  it "should destroy all using scope" do
    #SysLog.delete_all   #remove all entry in sys_log table
    FactoryGirl.create(:sys_log, :log_date => Time.now) 
    FactoryGirl.create(:sys_log, :log_date => 1.day.ago)
    FactoryGirl.create(:sys_log, :log_date => 2.days.ago)
    lambda do
      SysLog.trim_log(1)
    end.should change(SysLog, :count).by(-2)
  end
  
  it "should log right" do
    log = FactoryGirl.build(:sys_log)
    log.should be_valid
  end
  
  it "should reject nil log date" do
    log = FactoryGirl.build(:sys_log, :log_date => nil)
    log.should_not be_valid
  end

  it "should add one record in sys_logs table" do
    log = SysLog.new({:log_date => Time.now}, :as => :logger)
    lambda do
      log.save
    end.should change(SysLog, :count).by(1)
  end    
end
