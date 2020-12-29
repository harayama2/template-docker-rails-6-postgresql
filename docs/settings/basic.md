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
# IP White list
config.web_console.whitelisted_ips = '0.0.0.0/0'
```
