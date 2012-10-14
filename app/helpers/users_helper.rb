# encoding: utf-8
module UsersHelper
  
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

  def return_user_group
    SysUserGroup.order("user_group_name")
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
