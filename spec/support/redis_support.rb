require 'rails_helper'

module RedisSupport
  def redis_start
    start_redis = 'docker run --name redis -p 6379:6379 -d redis'
    puts start_redis
    result = system(start_redis)

    raise 'Not started tcp_server' if result.nil? || result == false
    sleep(15)
  end

  def redis_stop
    stop_redis = 'docker stop redis'
    system(stop_redis)
  end
end