web: bundle exec rackup config.ru -p $PORT
worker: bundle exec sidekiq -r ./app.rb -c 7 -v