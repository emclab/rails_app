class AddManagerToUserLevels < ActiveRecord::Migration
  def change
    add_column :user_levels, :manager, :string
  end
end
