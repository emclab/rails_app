class SysActionOnTable < ActiveRecord::Base
  
  has_many :sys_user_positions, :through => :sys_user_rights
  
end
