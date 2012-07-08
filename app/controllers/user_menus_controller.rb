# encoding: utf-8
class UserMenusController < ApplicationController
  #before_filter :require_signin
  helper_method 
  
  def index  
    #set session vars for viewing history
    @title = '系统管理'
    session[:page_step] = 1
    session[:page1] = user_menus_path
    render 'user_menus/index'
  end 
  
  protected
  
end
