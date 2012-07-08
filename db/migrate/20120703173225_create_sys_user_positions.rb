class CreateSysUserPositions < ActiveRecord::Migration
  def change
    create_table :sys_user_positions do |t|
      t.string :position_name
      t.string :position

      t.timestamps
    end
  end
end
