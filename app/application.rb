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
    mime_type :json, 'text/javascript'
  end

  namespace '/twitter' do
    get '/status' do
      content_type :json
      callback = params[:callback]
      redis = MyRedis.new
      "#{callback}(#{redis.get 'twitter'})"
    end
  end

end
