require 'net/http'
require "open-uri"

class GithubWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    redis = MyRedis.new
    github_user = Settings.new.github['user']

    response = URI.parse("https://api.github.com/users/#{github_user}").read

    puts ">>>>>>>>>>>>>>>>>", response.status
    redis.set 'github', response
  end
end
