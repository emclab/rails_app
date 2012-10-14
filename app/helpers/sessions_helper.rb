# encoding: utf-8
module SessionsHelper
#methods here can be accessed globally

  def grant_access?(action, table_name, record = nil)
    session[:user_privilege].has_action_right?(action, table_name, record)
  end
  
  private
  
  def current_user=(user)
    @current_user = user
  end   
   
end  # module  

