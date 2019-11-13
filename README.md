# README

Docker template for Rails6 and PG.

## Usage

```bash
$ mkdir YOUR_REPOSITORY_NAME
$ cd YOUR_REPOSITORY_NAME
$ git clone git@github.com:harayama-developmer/template-docker-rails-6-postgresql.git .
$ docker-compose build
$ docker-compose run --rm web bundle exec rails new . --force --database=postgresql --skip-test --skip-git --skip-turbolinks # Remove --skip-turbolinks if necessary
$ vi config/database.yml

default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  database: <%= ENV.fetch('DATABASE_NAME') { 'app_development' } %>
  username: <%= ENV.fetch('DATABASE_USER') { 'root' } %>
  password: <%= ENV.fetch('DATABASE_PASSWORD') { 'password' } %>
  host: <%= ENV.fetch('DATABASE_HOST') { 'localhost' } %>
  port: <%= ENV.fetch('DATABASE_PORT') { 5432 } %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default

$ docker-compose run --rm web bundle exec rails db:create
$ docker-compose up
```

Finally access `http://localhost:3000` on your browser.