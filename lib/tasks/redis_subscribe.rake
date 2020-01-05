namespace :redis_subscribe do
  desc 'Читать trace канала от ретранслятора'
  task :redis => :environment do
    $redis.subscribe('retranslator') do |on|
      on.message do |channel, message|
        Rails.logger.info("Broadcast on channel #{channel}: #{message}")
        RetranslatorChannel.broadcast_to 7, message
      end
    end
  end
end