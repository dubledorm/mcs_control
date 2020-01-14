class DbBackupJob < ApplicationJob
  queue_as :default

  rescue_from(Exception) do |exception|
    Rails.logger.error(exception.message)
  end

  def perform(program, user)
    Program::Backup::CreateService.new(program, user).call
  end
end