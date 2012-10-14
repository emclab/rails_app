class CreateSysModuleMappings < ActiveRecord::Migration
  def change
    create_table :sys_module_mappings do |t|
      t.integer :sys_module_id
      t.integer :sys_user_group_id

      t.timestamps
    end
  end
end
