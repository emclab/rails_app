# encoding: utf-8
class UserLevel < ActiveRecord::Base
  belongs_to :user 
  
  attr_accessible :position, :as => :admin   
  validates_presence_of :position, :message => '选择用户职位'
end
