class AddIndexToSysUserRights < ActiveRecord::Migration
  def change
    change_table :sys_user_rights do |t|
      t.index :sys_user_group_id
      t.index :sys_action_on_table_id
      t.index :accessable_column_name
    end
  end
end
