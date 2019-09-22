# encoding: UTF-8
class ProgramObserver < ActiveRecord::Observer

  def after_create(program)
    notify_instance(program)
  end

  def after_destroy(program)
    notify_instance(program)
  end

  private

    def notify_instance(program)
      instance = program.instance
      instance.state = 'changed'
      instance.save!
    end
end