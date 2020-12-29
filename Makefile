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
		cp .env.sample .env; rm .env.sample
login:
		docker-compose run --rm backend sh
dbc:
		docker-compose run --rm backend rails db:create

# Remove generated rails folders
rmrails:
		rm -rf app bin config db lib log node_modules public spec storage tmp vendor