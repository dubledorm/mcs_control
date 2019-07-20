class DeleteInstanceIdFromPort < ActiveRecord::Migration[6.0]
  def up
    remove_column :ports, :instance_id
  end

  def down
    add_column :ports, :instance,  :references, { null: false, foreign_key: true }
  end
end
