require 'twitter'

class TwitterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    minutely(1)
  end

  def perform
    me = Secrets.twitter.user('lxsameer')
    tweets_count = me.tweets_count
    friends = me.friends_count
    followers = me.followers_count
    latest_tweets = Secrets.twitter.user_timeline("lxsameer").each do |tweet|

    end

    puts "FRIENDS: #{friends}"
  end
end
