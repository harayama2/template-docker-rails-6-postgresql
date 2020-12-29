# README

Development template for Rails6.1 and PG.

```
NODE_VERSION: '14-alpine'
RUBY_VERSION: '2.7-alpine'
YARN_VERSION: '1.22.5'
RAILS_VERSION: '6.1'
```

## Usage

### 1. Build Image

```bash
$ mkdir YOUR_REPOSITORY_NAME
$ cd YOUR_REPOSITORY_NAME
$ git clone git@github.com:harayama-developmer/template-docker-rails-6-postgresql.git .
$ rm -rf .git/
$ make init
```

Please change to `.env` your preference.

### 2. Rails New

This command is uses `-m ./rails_template.rb` option.

```bash
$ docker-compose run --rm backend rails new . -m ./rails_template.rb -d postgresql -T
```

Please change to `rails new options` your preference.

#### Other Examples

```bash
$ docker-compose run --rm backend rails new . -d postgresql -T --skip-action-mailbox --webpack=stimulus
```

options:

- --database=postgresql
- --skip-active-storage
- --skip-action-mailer
- --skip-active-job
- --skip-action-cable
- --skip-action-mailbox
- --skip-action-text
- --skip-turbolinks
- --skip-sprockets
- --skip-spring
- --skip-bootsnap

### 3. Settings

**Edit `config/database.yml`.**

```yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  port: <%= ENV.fetch('DATABASE_PORT') { 5432 } %>
  username: <%= ENV['DATABASE_USER'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: <%= ENV['DATABASE_HOST'] %>

development:
  <<: *default
  database: <%= ENV['DATABASE_DEV_NAME'] %>

test:
  <<: *default
  database: <%= ENV['DATABASE_TEST_NAME'] %>

production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>
```

**Create database**

```bash
$ make dbc
```

**Start containers**

```bash
$ make
```

Access `http://localhost:3000` on your browser.

![rails_hello_world](https://user-images.githubusercontent.com/44060633/102802678-60cf1080-43fa-11eb-8918-bf2bacf0fbe9.png)

**End containers**

```bash
$ make down
```

## Customize

- [Basic Settings](docs/settings/basic.md)
- [Gems Settings](docs/settings/gems.md)
