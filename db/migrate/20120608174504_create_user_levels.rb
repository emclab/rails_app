class CreateUserLevels < ActiveRecord::Migration
  def change
    create_table :user_levels do |t|
      t.integer :user_id
      t.string :position

      t.timestamps
    end
  end
end
