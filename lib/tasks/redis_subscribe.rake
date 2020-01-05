namespace :redis_subscribe do
  desc 'Читать trace канала от ретранслятора'
  task :redis => :environment do
    RetranslatorChannel.broadcast_to 7, '111111111111111111'

    # $redis.subscribe('31028_31029') do |on|
    #   on.message do |channel, message|
    #     Rails.logger.info("Broadcast on channel #{channel}: #{message}")
    #     RetranslatorChannel.broadcast_to 7, message
    #   end
    # end
  end
end