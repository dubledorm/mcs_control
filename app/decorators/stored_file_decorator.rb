class StoredFileDecorator < ObjectBaseDecorator
  delegate_all

  def content_type
    I18n.t("values.stored_file.content_type.#{object.content_type}")
  end

  def state
    I18n.t("values.stored_file.state.#{object.state}")
  end
end