module ApplicationHelper

  def str_to_sym(value_str)
    value_str.parameterize.underscore.to_sym
  end

  def test_point_exception(enable = false)
    # Эта функция используется для тестов. На тесте будет заменяться на Exception
    raise StandardError, 'Test exception message' if test_point_exception_enable? || enable
  end

  def test_point_exception_enable?
    return false
  end
end
