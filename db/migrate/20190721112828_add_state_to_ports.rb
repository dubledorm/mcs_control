class AddStateToPorts < ActiveRecord::Migration[6.0]
  def change
    add_column :ports, :state, :string
  end
end
