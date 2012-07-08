# encoding: utf-8
module SessionsHelper

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "先登录！"
  end
  
  def position?(position)
    #the following is the naming convention of positions:
    # sales, eng, ceo, coo, vp_eng, vp_sales, acct, sales_dept_head, eng_dept_head, acct_dept_head
    # admin,
    # position?('ceo)
    session[:user_positions].include?(position) unless position.nil?
  end
  
  def user_type?(type)
    # user type
    # employee, customer, 
    # user_type?('employee')
    session[:user_type] == type unless type.nil?
  end
  

  private

   #def user_from_remember_token
   #  User.authenticate_with_salt(*remember_token)
   #end

   #def remember_token
   #  cookies.signed[:remember_token] || [nil, nil]
   #end

   def current_user=(user)
     @current_user = user
   end  
    
   #save user's poistion (admin, ceo etc) in session
   #save user type in session, types are employee and etc.    
   def set_user_rights
     #session[current_user.user_type.to_sym] = true 
     session[:user_type] = current_user.user_type
     session[:user_positions] = []
     
     self.current_user.user_levels.each do |r|
       #session[r.position.to_sym] = true 
       session[:user_positions] << r.position
     end
   end

end  # module  

