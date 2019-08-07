class ApplicationDecorator < Draper::Decorator

  DB_STATUS_TRANSLATE = {undefined: I18n.t('activerecord.decorate.instance.db_status.undefined'),
                         everywhere_exists: I18n.t('activerecord.decorate.instance.db_status.everywhere_exists'),
                         only_here_exists: I18n.t('activerecord.decorate.instance.db_status.only_here_exists'),
                         only_there_exists: I18n.t('activerecord.decorate.instance.db_status.only_there_exists')}

  def collate_base_status
    value = object.db_status
    value = :undefined if value.blank?

    DB_STATUS_TRANSLATE[value.to_sym]
  end
end
