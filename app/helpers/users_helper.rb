# encoding: utf-8
module UsersHelper
  
  def return_active_customer
    Customer.active_cust.order("id DESC")  
  end
    
  def return_employee(*list_position)
    User.where("user_type = ? AND status = ?", 'employee', 'active').joins(:user_levels).where(:user_levels => {:position => list_position })
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

  def return_position
    [ ['财会','acct'], ['系统管理员','admin'], ['工程副总','vp_eng'], ['市场副总', 'vp_sales'], ['总经理','coo'],['董事长','ceo']]
  end
  
  def return_position_name(position)
    case position
    when 'acct'
      '财会'
    when 'admin'
      '系统管理员'
    when 'vp_eng'
      '工程副总'
    when 'vp_sales'
      '市场副总'
    when 'coo'
      '总经理'
    when 'ceo'
      '董事长'
    end
  end
      
  #remove user position in system user creation
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  #add user position in system user creation
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render :partial => association.to_s, :locals => {:f => builder, :i_id => 0} 
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{j fields}\")")
  end
    
end
