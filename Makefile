build:
	docker-compose build

bundle:
	docker-compose run --rm library bundle install

test:
	docker-compose run --rm library bundle exec rake

rubocop:
	docker-compose run --rm library bundle exec rubocop

bash:
	docker-compose run --rm library bash
