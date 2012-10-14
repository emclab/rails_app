class RemoveSubGroupFromSysUserGroups < ActiveRecord::Migration
  def up
    remove_column :sys_user_groups, :sub_group
  end

  def down
    add_column :sys_user_groups, :sub_group, :string
  end
end
