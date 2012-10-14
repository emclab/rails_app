# encoding: utf-8
class UserLevel < ActiveRecord::Base
  before_save :check_data
  belongs_to :user 
    
  attr_accessible :position, :manager, :as => :admin   
  validates_presence_of :position, :message => '选择用户职位'
  
  def check_data
    position != manager 
  end
end
