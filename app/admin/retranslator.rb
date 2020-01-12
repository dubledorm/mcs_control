# encoding: UTF-8
ActiveAdmin.register Retranslator do
  permit_params :port_from, :port_to
  config.filters = false

  breadcrumb do
    breadcrumbs = [ link_to(I18n.t('words.admin'), admin_root_path()) ]
    breadcrumbs += [ link_to(I18n.t('activerecord.models.retranslator.other'),
                             admin_retranslators_path())] unless params[:action] == 'index'
    breadcrumbs
  end

  show do
    attributes_table do
      row :port_from
      row :port_to
      row :replacement_port
      row :active
      row :admin_user
      row :created_at
      row :updated_at
    end
    if resource.active?
      panel I18n.t('words.debug') do
        render 'admin/shared/retranslator_trace', channel_name: resource.channel_name
      end
    end
    active_admin_comments
  end


  form title: Retranslator.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.retranslator.attributes') do
      input :port_from
      input :port_to
    end

    actions
  end

  index do
    column :id
    column :port_from
    column :port_to
    column :replacement_port
    column :active
    column :admin_user
    column :created_at
    column :updated_at

    actions defaults: true do |retranslator|
      if retranslator.replacement_port && retranslator.active?
        item 'Выключить', retranslator_switch_off_url(Retranslator::find_by_replacement_port(retranslator.replacement_port))
      end
    end
  end
end