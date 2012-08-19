# encoding: utf-8
class UsersController < ApplicationController
  #before_filter :require_signin
  before_filter :require_employee 
  before_filter :require_admin  
  
  helper_method :return_user_positions, :return_user_type_name, :return_user_type, :return_user_status, 
                :return_user_status_name, :return_position, :return_position_name
    
  def index
    @title = "用户名单"
    @users = User.order("id DESC, status ASC").paginate(:per_page => 40, :page => params[:page])
  end

  def show
    @title = "用户内容"
    @user = User.find(params[:id])
  end

  def new
    @title = "输入用户"
    @user = User.new
    @user.user_levels.build
  end

  def create
    @user = User.new(params[:user], :as => :admin)
    @user.last_updated_by_id = session[:user_id]
    if @user.save
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=用户已保存！")
    else
      flash.now[:error] = '无法保存！'
      render 'new'
    end
  end

  def edit
    @title = "更改用户信息"
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.last_updated_by_id = session[:user_id]
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=更改已保存！")
    else
      flash.now[:error] = '修改无法保存！'
      render 'edit'
    end
  end
  
  protected
  
  #return user position string
  def return_user_positions(user)
    position = nil
    user.user_levels.each do |ul| 
      if position.nil?
        position = return_position_name(ul.position)
      else
        position = position + ', ' + return_position_name(ul.position)
      end
    end
    return position      
  end

  def return_user_status
    [['在职', 'active'], ['禁止登录','blocked'], ['离职', 'inactive']]
  end
  
  def return_user_status_name(status)
    case status
    when 'active'
      '在职'
    when 'blocked'
      '禁止登录'
    when 'inactive'
      '离职'
    end
  end
  
  def return_user_type
    [['员工', 'employee']]
  end
  
  def return_user_type_name(name)
    case name
    when 'employee'
      '员工'
    end
  end
 
  def return_position
    [ ['财会','acct'], ['系统管理员','admin'],
     ['工程副总','vp_eng'], ['市场副总', 'vp_sales'], ['总经理','coo'],['董事长','ceo']]
  end
  
  def return_position_name(position)
    pos = ''
    case position
    when 'admin'
      pos = '系统管理员'
    when 'ceo'
      pos = '董事长'
    when 'acct'
      pos = '财会'
    when 'vp_eng'
      pos = '工程副总'
    when 'eng'
      pos = '工程师'
    when 'coo'
      pos = '总经理'
    when 'vp_sales'
      pos = '销售副总'
    end
    return position if pos.nil?
    return pos
  end  
end
