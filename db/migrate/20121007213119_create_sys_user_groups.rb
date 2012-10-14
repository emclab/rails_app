class CreateSysUserGroups < ActiveRecord::Migration
  def change
    create_table :sys_user_groups do |t|
      t.string :user_group_name
      t.string :short_note

      t.timestamps
    end
  end
end
