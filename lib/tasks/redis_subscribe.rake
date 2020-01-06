namespace :redis_subscribe do
  desc 'Читать trace канала от ретранслятора'
  task :redis, [:channel_name] => [:environment] do |t, args|
    # (0..10).each do |i|
    #   RetranslatorChannel.broadcast_to(Retranslator.find(7), '21212121212121212-' + i.to_s)
    #   sleep(1)
    # end

    Rails.logger.debug("Subscribe on redis channel #{args[:channel_name]}")
    $redis.subscribe(args[:channel_name]) do |on|
      on.message do |channel, message|
        Rails.logger.debug("Broadcast on channel #{channel}: #{message}")
        retranslator = Retranslator.all.by_channel(args[:channel_name]).first
        if retranslator.nil?
          Rails.logger.error('Could not find retranslator for channel: ' + args[:channel_name])
          return
        end
        RetranslatorChannel.broadcast_to retranslator, message
      end
    end
  end
end