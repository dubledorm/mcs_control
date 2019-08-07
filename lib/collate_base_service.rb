
# Базовый класс для сравнения содержимого "здесь и там".
# Здесь - это объекты в нашей управляющей базе
# Там - это непосредственно объекты Инфосфера
# Задача класса - в нашей базе создать все недостающие объекты (т.е. в Инфосфере есть, а у нас нет)
# Проставить для всех объектов db_status


class CollateBaseService

  def initialize(parent_object)
    @parent_object = parent_object
  end

  def call
    # Получаем список объектов в Инфосфера
    there_object_list = get_there_object_list(parent_object)

    # Получаем аналогичный список объектов у нас
    here_object_list = get_here_object_list(parent_object)

    # Добавляем к нам те объекты, которые есть в Инфосфера, но нет у нас
    # При этом, ставим db_status для них only_there_exists
    new_object_list = there_object_list.find_all{ |object| here_object_list.exclude?(get_there_value(object))}
    new_object_list.each do |there_object|
       add_object_to_us(there_object, :only_there_exists)
    end

    # Проcтавляем состояние :only_here_exists
    (here_object_list - there_values(there_object_list)).each do |here_object|
      set_object_db_status(here_object, :only_here_exists)
    end

    # Проставляем состояние :everywhere_exists
    (here_object_list & there_values(there_object_list)).each do |everywhere_object|
      set_object_db_status(everywhere_object, :everywhere_exists)
    end
  end

  private

   # Возвращаем массив значений для сравнения
   def there_values(there_object_list)
     there_object_list.map{ |there_object| get_there_value(there_object) }
   end

  protected
    attr_accessor :parent_object

    def get_there_object_list(parent_object)
      raise NotImplementedError
    end

    def get_here_object_list(parent_object)
      raise NotImplementedError
    end

    def add_object_to_us(object_value, db_status)
      raise NotImplementedError
    end

    def set_object_db_status(object_value, db_status)
      raise NotImplementedError
    end

    # функция возвращает значение объекта для сравнения
    def get_there_value(object_value)
      object_value
    end
end
