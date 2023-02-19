# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version  
3.1.1
* System dependencies  
redis  
crontab  
* Configuration

* Database creation  
`bundle exec rails db:create`
* Database initialization  
`bundle exec rails db:migrate`
* How to run the test suite  
`make spec-all`  
* Services (job queues, cache servers, search engines, etc.)  
read Procfile.dev
* Deployment instructions  
install rvm - https://rvm.io/rvm/install    
install ruby - `rvm install ruby-3.1.1`  
install ruby dependencies - `bundle install`  
install redis - https://redis.io/docs/getting-started/installation/  
install npm - `sudo apt install npm`  
install js dependencies(npm) - `npm install`  
install yarn - `npm install --global yarn`  
install js dependencies(yarn) - `yarn install`  
start redis - `sudo service redis-servis status && sudo service redis-servis start`  
start crontab - read Makefile  
start app - `bin/dev`  
* ...
