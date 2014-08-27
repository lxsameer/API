require 'sidekiq'
require 'sidetiq'

require_relative "./app/settings"

Settings.services.each do |service|
  require_relative "./app/workers/#{service}"
end
