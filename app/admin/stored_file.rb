# encoding: UTF-8
ActiveAdmin.register StoredFile do
  menu parent: :resources
  decorate_with StoredFileDecorator
  config.filters = false

  breadcrumb do
    breadcrumbs = [ link_to(I18n.t('words.admin'), admin_root_path()) ]
    breadcrumbs += [ link_to(I18n.t('activerecord.models.stored_file.other'),
                             admin_stored_files_path())] unless params[:action] == 'index'
    breadcrumbs
  end

  action_item :download, only: :show  do
    link_to I18n.t('actions.program.download'), rails_blob_path(resource.file, disposition: "attachment")
  end
end