class AddAccessibleColumnNameToSysUserRights < ActiveRecord::Migration
  def change
    add_column :sys_user_rights, :accessible_column_name, :string
  end
end
