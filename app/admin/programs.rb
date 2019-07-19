ActiveAdmin.register Program do
  belongs_to :instance
  decorate_with ProgramDecorator
  actions :show, :new, :create, :destroy

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

  controller do
    def destroy
      @page_title = I18n.t('forms.activeadmin.confirm.delete_program_page_title', program_name: resource.identification_name)
      begin
        if params[:confirm].present?
          instance_id = resource.instance_id
          Program::Destructor::destroy_and_drop_db(resource)
          redirect_to admin_instance_path(id: instance_id)
        else
          render 'admin/shared/destroy_confirm', layout: 'active_admin',
                 locals: {title: I18n.t('forms.activeadmin.confirm.delete_program_message'),
                          back_path: admin_instance_program_path(id: resource.id, instance_id: resource.instance_id),
                          delete_path: admin_instance_program_path(id: resource.id, instance_id: resource.instance_id, confirm: true)
                         }
        end
      rescue StandardError => e
        redirect_to admin_instance_program_path(instance_id: resource.instance_id, id: resource.id), alert: e.message
      end
    end
 end
end
