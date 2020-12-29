**settings/**
## Base

#### config/application.rb
```rb
# Generator settings
config.generators do |g|
  g.assets false
  g.helper false
  g.jbuilder false
  g.test_framework :rspec,
                    controller_specs: false,
                    view_specs: false,
                    helper_specs: false,
                    routing_specs: false
end
# Default locale
config.i18n.default_locale = :ja

# Load locale files
config.i18n.load_path += Dir[
  Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
]

# Timezone
config.time_zone = 'Tokyo'
config.active_record.default_timezone = :local
```

#### config/environments/development.rb
```rb
# Don't care if the mailer can't send.
config.action_mailer.raise_delivery_errors = true

# Use an evented file watcher to asynchronously detect changes in source code,
# routes, locales, etc. This feature depends on the listen gem.
config.file_watcher = ActiveSupport::FileUpdateChecker

# IP White list
config.web_console.whitelisted_ips = '0.0.0.0/0'
```

#### config/puma.rb
Heroku settings:
[Deploying Rails Applications with the Puma Web Server
](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server)

#### config/locales/models.ja.yml
Example of `post` model.
```yml
ja:
  activerecord:
    models:
      post: 投稿
    attributes:
      post:
        title: タイトル
        description: 本文
```

#### config/locales/views/YOUR_CONTROLLER_NAME/ja.yml
Example of `home_controller`.
```yml
ja:
  home:
    index:
      title: 'ホーム画面'
      description: 'こちらはホーム画面です'
```