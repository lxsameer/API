require 'sinatra/base'
require 'sinatra/namespace'
require 'sidekiq'
require 'sidetiq'

require_relative './workers/twitter'
require_relative './workers/github'
require_relative './secrets'
require_relative './settings'
require_relative './lib/redis'

# Main Sinatra application class
class RadioApp < Sinatra::Application
  set :root, File.dirname(__FILE__)

  enable :sessions
  enable :logging

  configure do
    mime_type :jsonp, 'text/javascript'
    mime_type :json, 'text/json'

  end

  namespace '/twitter' do
    get '/status' do
      callback = params[:callback]
      redis = MyRedis.new

      if callback.nil?
        content_type :json
        redis.get 'twitter'
      else
        content_type :jsonp
        "#{callback}(#{redis.get 'twitter'})"
      end
    end
  end


  namespace '/github' do
    get '/status' do
      callback = params[:callback]
      redis = MyRedis.new

      if callback.nil?
        content_type :json
        redis.get 'github'
      else
        content_type :jsonp
        "#{callback}(#{redis.get 'github'})"
      end

    end
  end
end
