require 'net/http'

class GithubWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    redis = MyRedis.new
    github_user = Settings.new.github['user']

    response = Net::HTTP.get_response('api.github.com', "/users/#{github_user}", 80)

    if response.code != '200'
      STDERR.puts "#{response.code} - #{response.message}"
      return
    end

    redis.set 'github', response.body
  end
end
