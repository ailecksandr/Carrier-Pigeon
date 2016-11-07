require 'sinatra/reloader'

configure :development do
  set :show_exceptions, true
  register Sinatra::Reloader
end

configure :production do
  db = URI.parse ENV['DATABASE_URL']

  ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      host: db.host,
      username: db.user,
      password: db.password,
      db: db.path[1..-1],
      encoding: 'utf8'
  )

  uri = URI.parse ENV['REDISTOGO_URL']
  REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)

  Sidekiq.configure_server do |config|
    config.redis = REDIS
  end

  Sidekiq.configure_client do |config|
    config.redis = REDIS
  end
end