class SysModuleMapping < ActiveRecord::Base
  belongs_to :sys_user_group
  belongs_to :sys_module
end
