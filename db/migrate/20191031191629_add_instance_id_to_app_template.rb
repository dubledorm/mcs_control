class AddInstanceIdToAppTemplate < ActiveRecord::Migration[6.0]
  def change
    add_reference :nginx_templates, :instance, null: true
    add_column :nginx_templates, :for_instance_only, :boolean, default: false
  end
end
