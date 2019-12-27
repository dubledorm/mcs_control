namespace :health_request do
  desc 'Опросить состояние у mc'
  task :do_request => :environment do
    hc_logger = Logger.new("#{Rails.root}/log/health_check.log")
    Program.all.mc_only.each do |mc|
      begin
        HealthCheck::CheckOneServerService.new(mc, hc_logger).call
      rescue StandardError => e
        hc_logger.error("#{mc.identification_name} #{e.message}")
      end
    end
  end
end