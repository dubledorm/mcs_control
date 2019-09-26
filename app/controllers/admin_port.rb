module AdminPort
  include ApplicationHelper

  def create
    begin
      flash.delete(:alert)
      @resource = Port.new(params.require(:port).permit(:number, :program_id, :port_type))
      authorize! :extend, @resource.program
      Port::Factory::build(@resource)
      test_point_exception
      redirect_to admin_instance_program_path(id: @resource.program_id, instance_id: @resource.program.instance_id)
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to new_admin_program_port_path(program_id: params.require(:port)[:program_id]), error: e.message
    end
  end

  def destroy
    @page_title = I18n.t('forms.activeadmin.confirm.delete_port_page_title', port_number: resource.number)
    flash.delete(:error)
    program_id = resource.program_id
    instance_id = resource.program.instance_id
    begin
      if params[:confirm].present?
        authorize! :extend, resource.program
        test_point_exception
        Port::Destructor::simple_destroy(resource)
        redirect_to admin_instance_program_path(id: program_id, instance_id: instance_id)
      else
        render 'admin/shared/destroy_confirm', layout: 'active_admin',
               locals: {title: I18n.t('forms.activeadmin.confirm.delete_port_message'),
                        back_path: admin_instance_program_path(id: program_id, instance_id: instance_id),
                        delete_path: admin_program_port_path(program_id: resource.program_id, id: resource.id, confirm: true)
               }
      end
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_instance_program_path(id: program_id, instance_id: instance_id), error: e.message
    end
  end
end