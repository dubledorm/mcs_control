module AdminProgram
  include ApplicationHelper

  def new
    @need_database_create = false
    super
  end

  def create
    @need_database_create = str_to_bool(params.try(:[], :need_database_create))
    flash.delete(:error)
    begin
      if params.require(:program).require(:program_type) == 'mc'
        additional_name = params.require(:program).require(:additional_name)
      else
        additional_name = params.require(:program)[:additional_name]
      end
      resource = Program::Factory::build_and_create_db(Instance.find(params.require(:instance_id)),
                                                       params.require(:program).require(:program_type),
                                                       @need_database_create,
                                                       additional_name)
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