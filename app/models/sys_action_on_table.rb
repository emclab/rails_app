class SysActionOnTable < ActiveRecord::Base
  has_many :sys_user_groups, :through => :sys_user_rights
end
