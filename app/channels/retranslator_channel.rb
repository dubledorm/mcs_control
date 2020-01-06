class RetranslatorChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug('subscribed !!!!!!!!! params: ' + params.to_s)
    retranslator = Retranslator.all.by_channel(params[:retranslator]).first
    if retranslator.nil?
      Rails.logger.error('Could not find retranslator for channel: ' + params[:retranslator])
      return
    end
    stream_for retranslator
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def trace
  end
end
