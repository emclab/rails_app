class SysModule < ActiveRecord::Base
  #attr_accessible :module_group_name, :module_name
  has_many :sys_module_mappings
end
