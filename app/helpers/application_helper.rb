module ApplicationHelper

  def str_to_sym(value_str)
    value_str.parameterize.underscore.to_sym
  end
end
