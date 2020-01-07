ActiveAdmin.register Port do
  belongs_to :program
  decorate_with PortDecorator
  # actions :show, :new, :create, :destroy

  breadcrumb do
    [ link_to(I18n.t('words.admin'), admin_root_path()),
      link_to(I18n.t('activerecord.models.instance.other'), admin_instances_path()),
      link_to( resource.program.instance.name, admin_instance_path(id: resource.program.instance_id)),
      link_to( resource.program.identification_name,
               admin_instance_program_path(id: resource.program_id, instance_id: resource.program.instance_id))
    ]
  end

  show do
    if Retranslator::is_active?(resource.number)
      panel I18n.t('activerecord.models.retranslator.one') do
        render 'admin/shared/retranslator_warning', port: resource
      end

      panel I18n.t('words.debug') do
        render 'admin/shared/retranslator_trace',
               channel_name: Retranslator::find_by_replacement_port(resource.number)&.channel_name
      end
    end
    attributes_table do
      row :number
      row :program
      row :port_type
      row :db_status
      row :state
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end


  form title: Port.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.port.attributes') do
      render 'admin/port/form_top_text'
      input :program_id, as: :hidden
    end
    f.actions do
      f.action :submit
      f.cancel_link(admin_instance_program_path(id: resource.program_id, instance_id: resource.program.instance_id))
    end
  end

  member_action :retranslator_on, method: :put do
    begin
      test_point_exception
      Pf2::SwitchService::new(resource,true, current_user).call
      redirect_to admin_program_port_path(program_id: resource.program_id, id: resource.id), notice: "Switch On!"
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_program_port_path(program_id: resource.program_id, id: resource.id), error: e.message
    end
  end

  member_action :retranslator_off do
    begin
      test_point_exception
      Pf2::SwitchService::new(resource, false, current_user).call
      redirect_to admin_program_port_path(program_id: resource.program_id, id: resource.id), notice: "Switch Off!"
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_program_port_path(program_id: resource.program_id, id: resource.id), error: e.message
    end
  end

  controller do
    include AdminPort
  end
end