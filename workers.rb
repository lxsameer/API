require 'sidekiq'
require 'sidetiq'

require_relative './app/settings'
require_relative './app/secrets'
require_relative './app/lib/redis'

Settings.services.each do |service|
  require_relative "./app/workers/#{service}"
end
