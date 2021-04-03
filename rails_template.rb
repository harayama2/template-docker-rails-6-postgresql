# frozen_string_literal: true

# ==========================
# Gem settings
gem_group :test, :development do
  gem 'rubocop-airbnb', require: false
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_rewinder'
  gem 'bullet'
  gem 'pry-rails'
  gem 'pry-byebug'
end

gem_group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'html2slim'
  gem 'letter_opener_web'
end

gem 'rails-i18n'
gem 'slim-rails'

# ==========================
# Application settings

# --------------------------
# Base setting
base_setting = <<~TEXT
  # ==========================
  # Added
  # ==========================

  # Generator settings
  config.generators do |g|
    g.assets false
    g.helper false
    g.test_framework :rspec,
                      fixtures: true,
                      request_specs: true,
                      routing_specs: false,
                      view_specs: false,
                      helper_specs: false,
                      controller_specs: false
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
TEXT
environment base_setting

# --------------------------
# Development setting
development_application_setting = <<~TEXT
  # ==========================
  # Added
  # ==========================

  # IP White list
  config.web_console.whitelisted_ips = '0.0.0.0/0'

  # Show 'better_errors' console on docker
  BetterErrors::Middleware.allow_ip! '0.0.0.0/0'

  # Bullet setting
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
TEXT
environment development_application_setting, env: 'development'

# File watcher setting for docker
gsub_file 'config/environments/development.rb',
          'config.file_watcher = ActiveSupport::EventedFileUpdateChecker',
          'config.file_watcher = ActiveSupport::FileUpdateChecker'

# Action mailer error setting
gsub_file 'config/environments/development.rb',
          'config.action_mailer.raise_delivery_errors = false',
          'config.action_mailer.raise_delivery_errors = true'

# ==========================
# Routing settings
route "mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?"

# ==========================
# Database settings
run 'rm config/database.yml'
run "cat << TEXT > config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch('RAILS_MAX_THREADS') { 5 } %>
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
TEXT"

# ==========================
# CSS framework settings
run 'mkdir ./app/javascript/stylesheets'
run 'touch ./app/javascript/stylesheets/application.scss'

gsub_file 'app/views/layouts/application.html.erb',
          'stylesheet_link_tag',
          'stylesheet_pack_tag'

append_to_file 'app/javascript/packs/application.js' do
  <<~TEXT

    import "../stylesheets/application"
  TEXT
end

# ==========================
# Test settings
# --------------------------
# Rubocop
run "cat << TEXT > ./.rubocop_airbnb.yml
require:
  - rubocop-airbnb
TEXT"

run "cat << TEXT > ./.rubocop.yml
inherit_from:
  - .rubocop_airbnb.yml
AllCops:
#  TargetRubyVersion:
#  TargetRailsVersion:

  Exclude:
    - 'bin/**/*'
    - 'config/**/*'
    - 'db/**/*'
    - 'lib/**/*'
    - 'node_modules/**/*'
    - 'spec/**/*'
    - 'vendor/**/*'
    - 'rails_template.rb'
TEXT"

# --------------------------
# RSpec
run 'bundle install -j4'

# Setting rspec-rails
generate 'rspec:install'

run "cat << TEXT > ./.rspec
--require spec_helper
--format documentation
TEXT"

# Enable ./spec/support directory
run 'mkdir ./spec/support'
uncomment_lines 'spec/rails_helper.rb', /Dir\[Rails\.root\.join/

# Setting factory_bot_rails
run "cat << TEXT > ./spec/support/factory_bot.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
TEXT"

# Setting database_rewinder
run "cat << TEXT > ./spec/support/database_rewinder.rb
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseRewinder.clean_all
    # or
    # DatabaseRewinder.clean_with :any_arg_that_would_be_actually_ignored_anyway
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end
end
TEXT"

# ==========================
# View settings
run 'bundle exec erb2slim app/views app/views'
run 'bundle exec erb2slim app/views app/views -d'

# Database create and migration
if yes? 'run migrate? yes/no'
  rails_command 'db:create'
  rails_command 'db:migrate'
end

after_bundle do
  if yes? 'git commit? yes/no'
    git_email = ask('Your git email? :')
    git_username = ask('Your git username? :')
    git config: "--global user.email #{git_email}"
    git config: "--global user.name #{git_username}"

    git :init
    git add: '.'
    git commit: "-m 'First Commit'"
  end
end
