class TwitterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    minutely(3)
  end

  def perform
    puts 'Doing hard work'
  end
end
