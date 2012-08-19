class SysUserPosition < ActiveRecord::Base
  
  has_many :sys_action_on_tables, :through => :sys_user_rights
  
end
