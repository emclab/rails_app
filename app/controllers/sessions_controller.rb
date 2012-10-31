# encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :require_signin, :only => [:new, :create, :destroy]

  layout "sessions"
    
  def new
    
  end
  
  def create
    #redirect_to user_menus_path
    reset_session  #anti session fixation. must before assign session values
    user = User.authenticate(params[:login], params[:password]) 
    #collect user info
    session[:user_name] = params[:login] 
    session[:user_ip] = request.env['HTTP_X_FORWARDED_FOR'].nil? ? request.env['REMOTE_ADDR'] : request.env['HTTP_X_FORWARDED_FOR']  
    #good for client behind proxy or load balancer            
    if user.nil?
      #log 
      sys_logger('登录名/密码错误') unless Rails.env.test?  
      flash.now[:error] = "登录名/密码错误！"
      render 'new'
    elsif user.status == 'active'
      #assign session vars
      session[:user_id]  = user.id
      session[:user_name] = user.name
      session[:last_seen] = Time.now.utc   #db uses UTC time for timestamp
      session[:user_privilege] = UserPrivilege.new(user.id)
      assign_user_rights()
      #log
      sys_logger('登录') unless Rails.env.test?       
      redirect_to user_menus_path
    else
      #log 
      sys_logger('登录失败') unless Rails.env.test?      
      flash.now[:error] = "登录名/密码错误！"
      render 'new'
    end
  end
  
  def destroy
    sys_logger('退出') unless Rails.env.test?  
    sign_out
    redirect_to signin_path, :notice => "退出了!"
  end

end
