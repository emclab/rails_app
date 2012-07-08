class CreateSysUserRights < ActiveRecord::Migration
  def change
    create_table :sys_user_rights do |t|
      t.string :entry_name
      t.string :table_name
      t.string :action
      t.string :user_type
      t.string :user_position
      t.string :matching_column

      t.timestamps
    end
  end
end
