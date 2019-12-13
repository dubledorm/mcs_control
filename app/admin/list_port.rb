ActiveAdmin.register_page "ListPort" do
  menu label: proc { I18n.t("active_admin.list_port") }, parent: :resources

  breadcrumb do
    breadcrumbs = [ link_to(I18n.t('words.admin'), admin_root_path())]
    breadcrumbs += [ link_to(I18n.t("active_admin.list_port"), admin_listport_path())] unless params[:action] == 'index'
    breadcrumbs
  end

  controller do
    layout 'active_admin'

    def index
      flash.delete(:alert)
      @page_title = I18n.t("active_admin.list_port")
      if current_admin_user.admin?
        @list_port = Port.all.order(:number)
      else
        @list_port = current_admin_user.ports.order(:number)
      end
    end
  end
end
