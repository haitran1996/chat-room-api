server '13.231.143.62', port: 22, roles: [:web, :app], primary: true
set :repo_url, "git@github.com:haitran1996/chat-room-api.git"
set :stage, :staging
set :branch, :master
