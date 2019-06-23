class CreatePorts < ActiveRecord::Migration[6.0]
  def change
    create_table :ports do |t|
      t.integer :number, null: false, uniq: true
      t.references :instance, null: false, foreign_key: true

      t.timestamps
    end

    add_index :ports, :number
  end
end
