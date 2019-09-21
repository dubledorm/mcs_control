module AdminInstance
  include ApplicationHelper

  def scoped_collection
    if current_admin_user.admin?
      Instance.all
    else
      Instance.with_role(Role::ROLE_NAMES, current_admin_user)
    end
  end

  def new
    @need_database_create = true
    super
  end


  def create
    @need_database_create = str_to_bool(params.try(:[], :need_database_create))
    flash.delete(:error)
    create! { |success, failure|
      success.html do
        begin
          if @need_database_create
            Instance::Factory::build_and_create_db(resource)
          else
            Instance::Factory::build(resource)
          end
          redirect_to admin_instance_path(id: resource.id),
                      notice: I18n.t('forms.activeadmin.instance.created_succesfully')
        rescue StandardError => e
          flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
          render :new, error: e.message
        end
      end
      failure.html do
        flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: resource.errors.full_messages.join(','))
        render :new
      end
    }
  end

  def destroy
    @page_title = I18n.t('forms.activeadmin.confirm.delete_instance_page_title', instance_name: resource.name)
    flash.delete(:error)
    begin
      if params[:confirm].present?
        test_point_exception
        Instance::Destructor::destroy_and_drop_db(resource)
        redirect_to admin_instances_path
      else
        render 'admin/shared/destroy_confirm', layout: 'active_admin',
               locals: {title: I18n.t('forms.activeadmin.confirm.delete_instance_message'),
                        back_path: admin_instance_path(resource),
                        delete_path: admin_instance_path(resource, confirm: true)
               }
      end
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_instance_path(resource), error: e.message
    end
  end

end