class RemoveAccessableColumnNameFromSysUserRights < ActiveRecord::Migration
  def up
    remove_column :sys_user_rights, :accessable_column_name
  end

  def down
    add_column :sys_user_rights, :accessable_column_name, :string
  end
end
