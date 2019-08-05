ActiveAdmin.register Port do
  belongs_to :program
  decorate_with PortDecorator
  # actions :show, :new, :create, :destroy

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

  controller do
    include ApplicationHelper

    def create
      begin
        flash.delete(:alert)
        @resource = Port.new(params.require(:port).permit(:number, :program_id, :port_type))
        Port::Factory::build(@resource)
        test_point_exception
        redirect_to admin_instance_program_path(id: @resource.program_id, instance_id: @resource.program.instance_id)
      rescue StandardError => e
        flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
        redirect_to new_admin_program_port_path(program_id: params.require(:port)[:program_id]), error: e.message
      end
    end
  end
end