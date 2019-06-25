class AddProgramReferencesToPort < ActiveRecord::Migration[6.0]
  def change
    add_reference :ports, :program, index: true
    add_column :ports, :port_type, :string, index: true
  end
end
