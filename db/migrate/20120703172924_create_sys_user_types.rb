class CreateSysUserTypes < ActiveRecord::Migration
  def change
    create_table :sys_user_types do |t|
      t.string :type_name
      t.string :type

      t.timestamps
    end
  end
end
