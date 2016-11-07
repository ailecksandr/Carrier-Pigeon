web: bundle exec ruby web.rb -p $PORT
worker: bundle exec sidekiq -r ./app.rb -c 10 -v