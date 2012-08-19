class DropTableSysUserTypes < ActiveRecord::Migration
  def up
    drop_table :sys_user_types
  end

  def down
    create_table :sys_user_types do |t|
      t.string   "type_name"
      t.string   "type"
      
      t.timestamps
    end    
  end
end
