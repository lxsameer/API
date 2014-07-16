require 'rubygems'
require 'bundler'

Bundler.require

require './app/application'
require 'sidekiq/web'

run Rack::URLMap.new('/' => APIApp, '/sidekiq' => Sidekiq::Web)
