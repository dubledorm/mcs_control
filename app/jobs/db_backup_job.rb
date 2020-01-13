class DbBackupJob < ApplicationJob
  queue_as :default

  def perform(program, user)
    Program::Backup::CreateService.new(program, user).call
  end
end