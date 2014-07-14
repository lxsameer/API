require 'redis'

class MyRedis < Redis
  def initialize
    super **Secrets.redis
  end
end
