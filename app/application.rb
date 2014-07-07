require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'i18n'
require 'i18n/backend/fallbacks'

# Main Sinatra application class
class RadioApp < Sinatra::Application
  set :root, File.dirname(__FILE__)

  enable :sessions
  enable :logging

end
