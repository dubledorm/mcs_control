# encoding: UTF-8
class PortObserver < ActiveRecord::Observer

  def after_create(port)
    notify_instance(port)
  end

  def after_destroy(port)
    notify_instance(port)
  end

  private

  def notify_instance(port)
    instance = port.program.instance
    instance.state = 'changed'
    instance.save!
  end
end