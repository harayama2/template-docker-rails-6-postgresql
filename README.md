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

[Template details](rails_template.rb)

Please change to `rails new options` your preference.

#### Other Examples

```bash
$ docker-compose run --rm backend rails new . -d postgresql -T --skip-action-mailbox --webpack=stimulus
```

After rails new command, you must create database.

```bash
$ docker-compose run --rm backend rails db:create
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

### 3. Start containers

```bash
$ make
# or
# $ docker-compose up
```

Access `http://localhost:3000` on your browser.

![rails_hello_world](https://user-images.githubusercontent.com/44060633/102802678-60cf1080-43fa-11eb-8918-bf2bacf0fbe9.png)

**End containers**

```bash
$ make down
```
