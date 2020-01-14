namespace :stored_files do
  desc 'Удалить сохранённые файлы, хранящиеся более 3-х дней'
  task :delete_old => :environment do
    StoredFile.all.old_files.each do |stored_file|
      Rails.logger.info('Delete stored file ' + stored_file.filename)
      stored_file.destroy
    end
  end
end