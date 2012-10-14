# encoding: utf-8
class SysLogsController < ApplicationController
  #before_filter :require_signin
  #before_filter :require_employee
  
  helper_method :has_index_right?
  
  def index
    if has_index_right?
      @sys_logs = SysLog.order("id DESC").paginate(:per_page => 50, :page => params[:page])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  private
  
  # need to add more position for the app
  def has_index_right?
    session[:user_privilege].has_action_right?('index', 'sys_logs', nil) unless session[:user_privilege].nil?
  end
  
end
