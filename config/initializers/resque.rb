require 'redis'
if Rails.env.production?
  redis_config = {
    :host => 'mywoofapp.com',
    :port => 6379,
    :thread_safe => true
  }
else
  redis_config = {
    :host => '127.0.0.1',
    :port => 6379,
    :thread_safe => true
  }
end
$redis = Redis.new(redis_config)
Resque.redis = $redis
# Resque.logger.level = Logger::DEBUG
Resque.after_fork = Proc.new {
  ActiveRecord::Base.retrieve_connection
  $redis = Redis.new(redis_config)
  Resque.redis = $redis
  $junk = $redis
}
