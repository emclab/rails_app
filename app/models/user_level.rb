class UserLevel < ActiveRecord::Base
  belongs_to :user 
  attr_accessible :position   #protected by user controller. only user controller can acees user level.
  validates :position, :presence => true
end
