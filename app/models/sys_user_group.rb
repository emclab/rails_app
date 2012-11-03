class SysUserGroup < ActiveRecord::Base
  #attr_accessible :short_note, :user_group_name
  has_many :sys_user_rights
  has_many :sys_action_on_tables, :through => :sys_user_rights
end
