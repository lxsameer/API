require 'json'
require 'twitter'

class TwitterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(Settings.new.twitter['interval'].to_i) }

  def perform
    redis = MyRedis.new
    logger.info 'Twitter task started'
    me = Secrets.twitter.user('lxsameer')
    ltweets = Secrets.twitter.user_timeline("lxsameer").each do |tweet|
    end

    data = JSON.generate ({ tweets_count: me.tweets_count,
                            friends: me.friends_count,
                            followers: me.followers_count,
                            latest_tweets: ltweets})
    redis.set 'twitter', data
    logger.info 'Twitter task done'
  end
end
