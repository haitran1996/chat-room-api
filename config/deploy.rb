lock "~> 3.17.0"

set :user, 'deploy'
set :application, "chat-room-api"
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :keep_releases, 2

set :linked_files, %w(config/database.yml config/master.key .env)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)

set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :deploy_to,       "/var/www/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_rackup,  -> {File.join(current_path, "config.ru")}
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_conf,    -> {"#{shared_path}/puma.rb"}
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/dekisugi_id_rsa.pub) }
# keys on local, paste it to authorized_keys on server
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord