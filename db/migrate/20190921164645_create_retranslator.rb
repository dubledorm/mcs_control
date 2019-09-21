class CreateRetranslator < ActiveRecord::Migration[6.0]
  def change
    create_table :retranslators do |t|
      t.integer :port_from, null: false
      t.integer :port_to, null: false
      t.integer :replacement_port
      t.boolean :active
      t.timestamps
    end
  end
end
