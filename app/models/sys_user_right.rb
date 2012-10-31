class SysUserRight < ActiveRecord::Base
  attr_accessible :matching_column_name, :sys_action_on_table_id, :sys_user_group_id
  belongs_to :sys_user_group
  belongs_to :sys_action_on_table
end
