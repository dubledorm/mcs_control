# encoding: UTF-8
ActiveAdmin.register Program do
  belongs_to :instance
  decorate_with ProgramDecorator
  scope_to :current_admin_user, unless: proc{ current_admin_user.admin? }
  actions :show, :new, :create, :destroy

  breadcrumb do
    [ link_to(I18n.t('words.admin'), admin_root_path()),
      link_to(I18n.t('activerecord.models.instance.other'), admin_instances_path()),
      link_to( resource.instance.name, admin_instance_path(id: resource.instance_id))
    ]
  end

  action_item :add_port do
    link_to I18n.t('actions.program.add_port'), new_admin_program_port_path(program_id: resource.id) if can_add_port?
  end

  action_item :check, only: :show do
    link_to I18n.t('actions.instance.check'), check_admin_instance_program_path(id: resource.id, instance_id: resource.instance_id),
            method: :put if can_collate_with_db?
  end

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

    panel Program.human_attribute_name(:program) do
      render 'admin/shared/ports_show', ports: program.ports
    end
    active_admin_comments
  end

  controller do
    include ApplicationHelper
    def destroy
      @page_title = I18n.t('forms.activeadmin.confirm.delete_program_page_title', program_name: resource.identification_name)
      instance_id = resource.instance_id
      begin
        if params[:confirm].present?
          Program::Destructor::destroy_and_drop_db(resource)
          test_point_exception
          redirect_to admin_instance_path(id: instance_id)
        else
          render 'admin/shared/destroy_confirm', layout: 'active_admin',
                 locals: {title: I18n.t('forms.activeadmin.confirm.delete_program_message'),
                          back_path: admin_instance_program_path(id: resource.id, instance_id: resource.instance_id),
                          delete_path: admin_instance_program_path(id: resource.id, instance_id: resource.instance_id, confirm: true)
                         }
        end
      rescue StandardError => e
        flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
        redirect_to admin_instance_path(instance_id: instance_id), error: e.message
      end
    end
  end


  member_action :check, method: :put do
    begin
      test_point_exception
      Program::DatabaseControl::CollateDcsDevWithDbService.new(resource).call
      redirect_to admin_instance_program_path(id: resource.id, instance_id: resource.instance_id), notice: "Checked!"
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_instance_program_path(id: resource.id, instance_id: resource.instance_id), error: e.message
    end
  end
end
