all: build up ps
reset: downv prune build up ps
init: env build

prune:
		docker system prune -f
build:
		docker-compose build
up:
		docker-compose up -d
ps:
		docker-compose ps
down:
		docker-compose down
downv:
		docker-compose down -v
env:
		cp .env.sample .env
login:
		docker-compose run --rm backend sh
dbc:
		docker-compose run --rm backend rails db:create