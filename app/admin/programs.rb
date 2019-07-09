ActiveAdmin.register Program do
  menu false
  decorate_with ProgramDecorator

  show title: :identification_name do
    attributes_table do
      row :identification_name
      row :instance
      row :program_type
      row :additional_name
      row :database_name
      row :collate_base_status
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

end
