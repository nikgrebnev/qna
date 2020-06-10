# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails"
require "capistrano/puma"
require "capistrano/sidekiq"

# install_plugin Capistrano::Sidekiq
# install_plugin Capistrano::Sidekiq::Monit
# # sidekiq monit
# :sidekiq_monit_templates_path => 'config/deploy/templates'
# :sidekiq_monit_conf_dir => '/etc/monit/conf.d'
# :sidekiq_monit_use_sudo => true
# :monit_bin => '/usr/local/bin/monit'
# :sidekiq_monit_default_hooks => true
# :sidekiq_monit_group => nil
# :sidekiq_service_name => "sidekiq_#{fetch(:application)}"

#require "thinking_sphinx/capistrano"
#require "whenever/capistrano"

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
