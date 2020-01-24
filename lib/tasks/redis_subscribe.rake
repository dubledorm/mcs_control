namespace :redis_subscribe do
  desc 'Читать trace канала от ретранслятора'
  task :redis => [:environment] do |t, args|

    if $redis.nil?
      Rails.logger.error('Could not subscribe on redis channel. The $redis was not defined')
      ap('Could not subscribe on redis channel. The $redis was not defined')
      return
    end

    Rails.logger.debug("Subscribe on redis channels: #{ Retranslator.channel_names }")
    $redis.subscribe( Retranslator.channel_names ) do |on|
      on.message do |channel, message|
        Rails.logger.debug("Broadcast on channel #{channel}: #{message}")
        retranslator = Retranslator.all.by_channel(channel).first
        if retranslator.nil?
          Rails.logger.error('Could not find retranslator for channel: ' + channel)
          return
        end
        RetranslatorChannel.broadcast_to retranslator, message
      end
    end
  end
end