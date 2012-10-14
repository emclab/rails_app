class UserPrivilege
  def initialize(user_id)
    @user_id = user_id    #@user_id used below
    @user_sub_groups = find_sub_groups  
    @user_manager_groups = find_manager_groups
    @user_action_rights = find_action_rights
    @user_groups = find_user_groups
  end
  
  def sub_groups
    return @user_sub_groups
  end
  
  def action_rights
    return @user_action_rights
  end
  
  def manager_groups
    return @user_manager_groups
  end
  
  def user_groups
    return @user_groups
  end
  
  def find_user_groups
    @user_groups = []
    User.find_by_id(@user_id).user_levels.each do |ul|
      @user_groups << ul.position unless @user_groups.include?(ul.position)
    end  
    return @user_groups
  end
  
  def find_sub_groups
    @user_sub_groups = []
    User.find_by_id(@user_id).user_levels.each do |ul|
      UserLevel.where("manager = ?", ul.position).each do |sub|
        @user_sub_groups << sub.position if sub.position.present? && !@user_sub_groups.include?(sub.position)
        return_sub(sub.position) if sub.position.present?
      end
    end
    return @user_sub_groups
  end
  
  def return_sub(sub_group)
    line_record = UserLevel.where("manager = ?", sub_group)
    return if line_record.blank? 
    line_record.each do |lr|
      @user_sub_groups << lr.position if lr.position.present? && !@user_sub_groups.include?(lr.position)
      return_sub(lr.position) if lr.position.present?
    end
  end
  
  def find_manager_groups
    @user_manager_groups = []
    User.find_by_id(@user_id).user_levels.each do |ul|
      @user_manager_groups << ul.manager if ul.manager.present? && !@user_manager_groups.include?(ul.manager)
      return_manager(ul.manager) if ul.manager.present?
    end
    return @user_manager_groups
  end
  
  def return_manager(position)
    line_record = UserLevel.where("position = ?", position)
    return if line_record.blank? 
    line_record.each do |lr|
      @user_manager_groups << lr.manager if lr.manager.present? && !@user_manager_groups.include?(lr.manager)
      return_manager(lr.manager) if lr.manager.present?
    end
  end
  
  def find_action_rights
     rights = []
     User.find_by_id(@user_id).user_levels.each do |position|
       SysUserRight.joins(:sys_user_group).where("sys_user_groups.user_group_name = ?", position.position).each do |right|
         SysActionOnTable.where("id = ?", right.sys_action_on_table_id).each do |action_on_table|
           rights << [action_on_table.action, action_on_table.table_name] if !rights.include?([action_on_table.action, action_on_table.table_name])
         end
       end
     end
     return rights
  end
  
  def has_action_right?(action, table_name, record = nil)
    #record is the database record that needs to be accessed
    return false if action.nil? || table_name.nil?
    if @user_action_rights.include?([action, table_name])
      if record.nil?
        return true
      else
        #check if the value of matching_column in record is equal to the @user id
        action_record = SysActionOnTable.where("action = ? AND table_name = ?", action, table_name).first  #should only have one record
        SysUserRight.joins(:sys_user_group).where("sys_user_rights.sys_action_on_table_id = ?", action_record.id).where(:sys_user_groups => {:user_group_name => @user_groups}).each do |right|        
          return true if right.matching_column_name.present? && has_matching_column?(right.matching_column_name, record)
        end
      end  
    else
      return false
    end
  end
  
  def has_matching_column?(column_name, record)
    return true if record.send(column_name) == @user_id
  end
  
end