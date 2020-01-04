class RetranslatorChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    puts('subscribed !!!!!!!!! params: ' + params.to_s)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def trace
  end
end
