# app
app-start:
	bin/dev

# cron
cron-list:
	crontab -l
cron-start:
	sudo service cron start
	whenever --update-crontab
cron-start-dev:
	sudo service cron start
	whenever --update-crontab --set environment='development'
cron-stop:
	whenever --clear-crontab

# specs
spec-all:
	bundle exec rspec spec