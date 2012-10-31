class AddAccessableColumnNameToSysUserRights < ActiveRecord::Migration
  def change
    add_column :sys_user_rights, :accessable_column_name, :string
  end
end
