class ChangeColumnNameOfInstance < ActiveRecord::Migration[6.0]
  def up
    remove_index :instances, :name
    add_index :instances, :name, unique: true
  end

  def down
    remove_index :instances, :name
    add_index :instances, :name
  end
end
