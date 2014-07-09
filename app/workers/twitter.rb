require 'twitter'

class TwitterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    minutely(1)
  end

  def perform
    friends = Secrets.twitter.friends.take(20)
    puts "FRIENDS: #{friends}"
  end
end
