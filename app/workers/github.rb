require 'open-uri'

class GithubWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely }

  def perform
    redis = MyRedis.new
    github_user = Settings.new.github['user']

    logger.info "Github User: #{github_user}"
    logger.info "URI: https://api.github.com/users/#{github_user}"

    begin
      response = URI.parse("https://api.github.com/users/#{github_user}").read
      redis.set 'github', response
    rescue OpenURI::HTTPError
      logger.error 'There is something wrong with github url.'
      logger.error 'please double check your configs'
      redis.set 'github', '{}'
    end
  end
end
