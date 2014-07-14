require 'twitter'

class TwitterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    redis = MyRedis.new

    me = Secrets.twitter.user('lxsameer')
    redis.set 'twitter_tweets_count', me.tweets_count
    redis.set 'twitter_friends', me.friends_count
    redis.set 'twitter_followers', me.followers_count
    redis.set 'twitter_latest_tweets', Secrets.twitter.user_timeline("lxsameer").each do |tweet|
    end

  end
end
