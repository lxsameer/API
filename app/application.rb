require 'sinatra/base'
require 'sinatra/namespace'
require 'sidekiq'
require 'sidetiq'

require_relative './workers/twitter'
require_relative './secrets'
require_relative './lib/redis'

# Main Sinatra application class
class RadioApp < Sinatra::Application
  set :root, File.dirname(__FILE__)

  enable :sessions
  enable :logging

  namespace '/twitter' do
    get '/status' do
      redis = MyRedis.new
      redis.get 'twitter'
    end
  end

end
