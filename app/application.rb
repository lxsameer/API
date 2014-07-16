require 'sinatra/base'
require 'sinatra/namespace'
require 'sidekiq'
require 'sidetiq'

require_relative './secrets'
require_relative './settings'
require_relative './lib/redis'

# Main Sinatra application class
class RadioApp < Sinatra::Application
  set :root, File.dirname(__FILE__)

  enable :sessions
  enable :logging

  Sidetiq.configure do |config|
    config.handler_pool_size = 1
  end

  configure do
    mime_type :jsonp, 'text/javascript'
    mime_type :json, 'text/json'
  end


  ['github', 'twitter'].each do |service|

    require_relative "./workers/#{service}"

    namespace "/#{service}" do
      get '/status' do
        callback = params[:callback]
        redis = MyRedis.new

        if callback.nil?
          content_type :json
          redis.get service
        else
          content_type :jsonp
          "#{callback}(#{redis.get service})"
        end
      end
    end
  end
end
