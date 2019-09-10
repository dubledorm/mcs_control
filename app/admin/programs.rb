# encoding: UTF-8
ActiveAdmin.register Program do
  belongs_to :instance
  decorate_with ProgramDecorator
  scope_to :current_admin_user, unless: proc{ current_admin_user.admin? }
  actions :all, except: [:index]
  permit_params :program_type, :additional_name, :database_name

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

  form title: Program.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.program.attributes') do
      input :program_type_show_only, as: :select, collection: available_program_types,
            selected: params[:program_type],
            label: Program.human_attribute_name(:program_type),
            input_html: { :disabled => true }
      input :additional_name, required: true
      input :program_type, input_html: { value: params[:program_type] }, as: :hidden
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
    include ApplicationHelper

    def new
      @need_database_create = false
      super
    end

    def create
      @need_database_create = str_to_bool(params.try(:[], :need_database_create))
      flash.delete(:error)
      begin
        resource = Program::Factory::build_and_create_db(Instance.find(params.require(:instance_id)),
                                                         params.require(:program).require(:program_type),
                                                         @need_database_create,
                                                         params.require(:program).require(:additional_name))
        test_point_exception
        redirect_to admin_instance_program_path(instance_id: resource.instance_id, id: resource.id),
                    notice: I18n.t('forms.activeadmin.program.created_succesfully')
      rescue StandardError => e
        Program::Destructor::destroy_and_drop_db(resource) if resource && resource.persisted?
        flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
        redirect_to new_admin_instance_program_path(instance_id: params[:instance_id],
                                                    program_type: params[:program][:program_type]),
                    error: e.message
      end
    end

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
