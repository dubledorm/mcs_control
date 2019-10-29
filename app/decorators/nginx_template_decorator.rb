class NginxTemplateDecorator < Draper::Decorator
  delegate_all

  def program_type
    '' if object.program_type.blank?
    I18n.t("values.program_type.#{object.program_type}")
  end
end
