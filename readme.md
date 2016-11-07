# Carrier Pigeon ![Carrier Pigeon](app/assets/images/readme.png)

##### A simple application with secure delivering of messages.

1. Encrypt your message by password.
2. Decide how message will be removed.
3. Receive token to your message.
4. Whisper about the token to your friend.
5. He'll find the message and read it with your password.
6. Message will be removed when your criteria will be achieved.
7. Profit.  
![Deal with it](app/assets/images/readme1.png)

##### Server-side settings

1. Install gems
    `ruby bundle install`.
2. Prepare your dev db
    `ruby bundle exec rake db:create db:migrate`.
3. Move to Project folder.
    `cd carrier_pigeon`.
4. Run Redis-server
    `ruby redis-server`.
5. Run Web-Brick server of the application.
    `ruby bundle exec rackup`.
6. Run Sidekiq for moving queues of removable messages
    `ruby bundle exec sidekiq -r ./app.rb`.
7. Site will be located on 
    `http://localhost:9292`.
    
P.S. To begin rspec tests you must migrate test db.
    `ruby bundle exec rake db:migrate RACK_ENV=test`
    And simply run `ruby rspec/spec`. Results will appear in folder `coverage/`.

