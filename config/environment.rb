require 'sinatra/reloader'

configure :development do
  set :show_exceptions, true
  register Sinatra::Reloader
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

  ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :db => db.path[1..-1],
      :encoding => 'utf8'
  )

  Sidekiq.configure_server do |config|
    config.redis = {
        url: 'redis://localhost:6379',
        namespace: 'my_app_name_production'
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
        url: 'redis://localhost:6379',
        namespace: 'my_app_name_production'
    }
  end
end