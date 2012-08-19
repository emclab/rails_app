class SysUserRight < ActiveRecord::Base

  belongs_to :sys_action_on_table
  belongs_to :sys_user_position  
end
