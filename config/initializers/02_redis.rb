def redis_connection_options
  redis_config = YAML.load(ERB.new(File.read("#{Rails.root.to_s}/config/redis.yml")).result)[Rails.env].symbolize_keys
  {
      :host => redis_config[:host],
      :port => redis_config[:port],
      :db   => redis_config[:database],
      :timeout => 5
  }
end

def redis_init
  if ENV['REDIS_CLOUD_URL'].blank?
    Rails.logger.error('Could not find redis. You have to set enviroment variable REDIS_CLOUD_URL')
    return
  end
  $redis =  Redis.new(url: ENV['REDIS_CLOUD_URL'])
  Rails.logger.error('Could not connect to redis by url ' + ENV['REDIS_CLOUD_URL']) if $redis.nil?
end