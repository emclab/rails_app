# encoding: utf-8
class SysLog < ActiveRecord::Base
  attr_accessible :log_date, :user_name, :user_id, :user_ip, :action_logged, :as => :logger
  
  validates :log_date, :presence => true
  
  def self.trim_log(num_entry)
    if SysLog.count > num_entry      
      SysLog.where("log_date < ?", SysLog.offset(num_entry -1).first.log_date).delete_all
    end
  end
end
