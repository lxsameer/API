require 'net/http'
require 'rexml/document'

class OhlohWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(Settings.new.ohloh['interval'].to_i) }

  def perform
    redis = MyRedis.new

    api_key = Secrets.ohloh_key
    ohloh_user = Settings.new.ohloh['user']
    response = Net::HTTP.get_response('www.ohloh.net', "/accounts/#{ohloh_user}.xml?v=1&api_key=#{api_key}", 80)

    if response.code != '200'
      logger.error "[OHLOH] #{response.code} - #{response.message}"
      return
    end

    # Parse the response into a structured XML object
    xml = REXML::Document.new(response.body)
    # Did Ohloh return an error?
    error = xml.root.get_elements('/response/error').first
    if error
      logger.error "[OHLOH] #{error.text}"
      return
    end


    xml_kudo_rank = xml.root.get_elements('/response/result/account/kudo_score/kudo_rank').first
    kudo_rank = xml_kudo_rank ? xml_kudo_rank.text.to_i : 1
    position = xml.root.get_elements('/response/result/account/kudo_score/position').first.text

    redis.set 'ohloh', JSON.generate({rank: position, level: kudo_rank})

  end
end
