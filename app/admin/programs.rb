# encoding: UTF-8
ActiveAdmin.register Program do
  belongs_to :instance
  decorate_with ProgramDecorator
  scope_to :current_admin_user, unless: proc{ current_admin_user.admin? }
  actions :all, except: [:index, :edit, :update]
  permit_params :program_type, :additional_name, :database_name

  breadcrumb do
    [ link_to(I18n.t('words.admin'), admin_root_path()),
      link_to(I18n.t('activerecord.models.instance.other'), admin_instances_path()),
      link_to( resource.instance.name, admin_instance_path(id: resource.instance_id))
    ]
  end

  action_item :add_port do
    link_to I18n.t('actions.program.add_port'), new_admin_program_port_path(program_id: resource.id) if program_can_add_port?
  end

  action_item :check, only: :show do
    link_to I18n.t('actions.instance.check'), check_admin_instance_program_path(id: resource.id, instance_id: resource.instance_id),
            method: :put if program_can_collate_with_db?
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

    panel Program.human_attribute_name(:ports) do
      render 'admin/shared/ports_show', ports: program.ports,
             can_delete_ports: program_can_delete_port?,
             can_retranslate_ports: program_can_retranslator?
    end
    active_admin_comments
  end

  form title: Program.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.program.attributes') do
      if (params[:program_type].blank?)
        input :program_type, as: :select, collection: options_for_select(program_available_program_types),
              label: Program.human_attribute_name(:program_type)
      else
        input :program_type, as: :select,
              collection: options_for_select(program_available_program_types, params[:program_type]),
              label: Program.human_attribute_name(:program_type),
              input_html: { disabled: true }
        input :program_type, input_html: { value: params[:program_type] }, as: :hidden
      end
      input :additional_name, required: params[:program_type] == 'mc' ? true : false
    end

    unless resource.persisted?
      inputs I18n.t('forms.activeadmin.instance.create_database_title') do
        render 'admin/shared/cb_and_label', variable_name: :need_database_create,
               variable_title: I18n.t('forms.activeadmin.program.need_database_create'),
               checked: need_database_create || false
      end
    end
    f.actions do
      f.action :submit
      f.cancel_link(admin_instance_path(id: params[:instance_id]))
    end
  end

  controller do
    include AdminProgram
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
