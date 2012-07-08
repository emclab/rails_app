# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_signin
  before_filter :session_timeout
  
  #for methods available to the whole app
  helper_method 

  #make session related method available to all controllers
  include SessionsHelper
  
  #before_filter method for session time control. 1. reset session after SESSION_TIMEOUT_MINUTES. 
  #2. Delete session entry after SESSION_WIPEOUT_HOURS.
  #define session[:last_see] initial in utc format.
  #Also bypass in test environment.
  def session_timeout
    #return if Rails.env.test?
    #check session last_seen
    if session[:last_seen] < SESSION_TIMEOUT_MINUTES.minutes.ago
      reset_session
    else
      session[:last_seen] = Time.now.utc
    end unless session[:last_seen].nil?
    #check when session created
    if Session.first.created_at < SESSION_WIPEOUT_HOURS.hours.ago
      Session.sweep
    end unless Session.first.nil?
  end
  
  #before_filter in controller to see if the user is the company employee
  def require_employee
    if !user_type?('employee') 
      flash.now[:error] = "登录被拒!"
      redirect_to root_path
    end
  end
  
  #before_filter in controller to see if the user is admin
  def require_admin
    position?('admin')
  end
  
  #before_filter in controller to check if user signed in.
  def require_signin
    if !signed_in?  
      flash.now.alert = "先登录!"
      redirect_to signin_path
    end
  end   

  #retrieve @current_user for controller and view.
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def sign_in(user)
    #cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    set_user_rights
  end  

  def signed_in?
    !current_user.nil?
    #!session[:user_id].nil? || session[:user_id] <= 0
  end
  
  def sign_out
    #cookies.delete(:remember_token)
    self.current_user = nil
    reset_session
  end  
  
  #remember the viewing history. :url and :index passed in from the link as params.
  # :index =0 means backword, :index=1 means forward. When forwarding, url is the url to save for back.
  def view_handler
    index  = params[:index].to_i
    url = params[:url]
    msg = params[:msg]
    if index == 0   #backword
      session[:page_step] -= 1  #step_back
      url = session[('page' + session[:page_step].to_s).to_sym]      
    else  #forward
      session[:page_step] += 1 
      session[('page' + session[:page_step].to_s).to_sym] = url
    end

    #redirect to the page by url  
    if msg.nil?                                                         
      redirect_to url
    else
      redirect_to url, :notice => msg
    end   
  end

  #simple logging for a user with id, ip address, name, datetime and action.
  def sys_logger(action_logged)
    log = SysLog.new({:log_date => Time.now, :user_id => session[:user_id], :user_name => session[:user_name], :user_ip => session[:user_ip],
                     :action_logged => action_logged}, :as => :logger)
    log.save!
  end
  
  #consult sys_user_right to grant access to table
  def grant_access?(table_name, action, obj)
    #'table name' is the name of table upon which the user is requesting the access for 'action'
    # 'action' is the action the user is going to take upon the obj
    #'obj' is the record upon which the user is requesting the acess for 'action'. obj can be nil.
    return false if table_name.blank? || action.blank? || session[:user_type].blank? || session[:user_positions].blank?
    pos = []
    # return position array in sys user right table
    SysUserRight.where("table_name = ? AND action = ? AND user_type = ?", table_name, action, session[:user_type]).each do |p|
      return false if p.matching_column.present? && obj.blank?
      if p.matching_column.blank?
        pos << p.user_position 
      else
        pos << p.user_position if obj.send(p.matching_column) == session[:user_id]
      end 
    end 
    # return array intersection
    (pos & session[:user_positions]).present?
  end
  
end
