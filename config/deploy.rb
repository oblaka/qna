# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'QnA'
set :repo_url, 'git@github.com:oblaka/qna.git'
# set :branch, 'lesson22'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/private_pub.yml',
                                                 'config/private_pub_thin.yml',
                                                 '.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'vendor/bundle',
                                               'public/system',
                                               'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :bundle_flags, '--deployment'
set :log_level, :debug

# before 'deploy', 'rvm1:install:gems'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end
  after :publishing, :restart
end

# Private Pub
namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

# Thinking Sphinx typing shortcuts
namespace :ts do
  desc 'Start search server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ts:index'
          execute :rake, 'ts:start'
        end
      end
    end
  end

  desc 'Stop search server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ts:stop'
        end
      end
    end
  end

  desc 'Restart search server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ts:index'
          execute :rake, 'ts:rebuild'
        end
      end
    end
  end
end

# # Monit tasks
# namespace :monit do
#   task :start do
#     run 'monit'
#   end
#   task :stop do
#     run 'monit quit'
#   end
# end

# # Stop Monit during restart
# before 'unicorn:restart', 'monit:stop'
# after 'unicorn:restart', 'monit:start'

after 'deploy:restart', 'ts:restart'
after 'deploy:restart', 'private_pub:restart'
