require 'open-uri'

class GithubWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(Settings.new.github['interval'].to_i) }

  def perform
    redis = MyRedis.new
    github_user = Settings.new.github['user']

    logger.info "Github User: #{github_user}"
    logger.info "URI: https://api.github.com/users/#{github_user}"

    begin
      response = URI.parse("https://api.github.com/users/#{github_user}").read
      #contributes = URI.parse("https://github.com/users/#{github_user}/contributions_calendar_data").read
      #contributes = JSON.parse contributes

      commits = 0
      #contributes.each do |day|
        #commits += day[1]
      #end

      response = JSON.parse response
      response['commits'] = '-'
      response['contribution_data'] = []

      redis.set 'github', JSON.generate(response)
      logger.info 'Value is set correctly'

    rescue OpenURI::HTTPError => err
      logger.error 'There is something wrong with github url.'
      logger.error 'please double check your configs'
      logger.error "ERRSTRING: #{err}"
      redis.set 'github', '{}'
    end
  end
end
