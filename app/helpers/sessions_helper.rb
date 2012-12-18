# encoding: utf-8
module SessionsHelper
#methods here can be accessed globally

  def grant_access?(action, table_name, accessible_column_name = nil, record = nil)
    if  accessible_column_name.nil? && record.nil?
      session[:user_privilege].has_action_right?(action, table_name)
    elsif accessible_column_name.present? && record.nil?
      session[:user_privilege].has_action_right?(action, table_name, accessible_column_name)
    elsif accessible_column_name.nil? && record.present?
      session[:user_privilege].has_action_right?(action, table_name, '', record)
    else
      session[:user_privilege].has_action_right?(action, table_name, accessible_column_name, record)
    end
  end

  def belongs_to_module_group?(module_group_name)
    session[:user_privilege].belongs_to_module_group?(module_group_name)
  end

  private
  
  def current_user=(user)
    @current_user = user
  end

end  # module  

