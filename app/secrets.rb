class Secrets
  def self.twitter
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def self.redis
    if ENV.include? 'REDIS_PASSWORD'
      { host: ENV['OPENSHIFT_REDIS_HOST'],
        port: ENV['OPENSHIFT_REDIS_PORT'],
        db: 15,
        password: ENV['REDIS_PASSWORD']
      }
    else
      {}
    end
  end

  def self.ohloh_key
    ENV['OHLOH_KEY']
  end

end
