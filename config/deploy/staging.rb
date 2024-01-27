server '35.77.230.55', port: 22, roles: [:web, :app], primary: true
set :repo_url, "git@github.com:haitran1996/chat-room-api.git"
set :stage, :staging
set :branch, :master
