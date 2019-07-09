ActiveAdmin.register Program do
  menu false

  show do
    attributes_table do
      row :identification_name
      row :instance
      row :program_type
      row :additional_name
      row :database_name
      row :db_status do |program|
        program.decorate.collate_base_status
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
