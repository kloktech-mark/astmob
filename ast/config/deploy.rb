set :application, "ast"
# (TODO) Rename to your own repo
set :repository,  "https://svn.yourhost.com/svn/trunk/ops/open_ast"
set :port_number, "4500"
# (TODO) Use if needed
#set :gateway, "gateway.yahoo.com"
set :use_sudo, true
# (TODO) Change to installation directory
set :deploy_to, "/home/example/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :keep_releases, 20  # Keep 20 copies
after "deploy:update", "deploy:cleanup"  

# Run as yourself so it DOES NOT execute sudo -u $user_name sh -c $cmd,
# it would just do sudo sh -c $cmd  
set :runner, nil

# (TODO) Configure to your ast hostname
role :app, "ast101.example.com"

def sudo_root
  set :sudo, "sudo"
end

# =============================================================================
# TASKS
# =============================================================================


task :after_symlink do
  p "Selecting colo specific database yml file"
#  run "/home/example/ast/current/config/select_database.sh"
end

namespace :deploy do
  
  task :start, :roles => :app do
    deploy.mongrel.start
  end
  task :stop, :roles => :app do
    deploy.mongrel.stop
  end
  task :restart, :roles => :app do
    deploy.mongrel.restart
    run "echo \"WEBSITE HAS BEEN DEPLOYED\""
  end
  task :setup do
    sudo_root
    dirs = [deploy_to, releases_path, shared_path]
    dirs += %w(system log pids).map { |d| File.join(shared_path, d) }
    sudo "mkdir -p #{dirs.join(' ')}"
    sudo "chmod -R 775 #{dirs.join(' ')}"
    # (TODO) Change permission
    sudo "chown -R ops:ops #{dirs.join(' ')}"
  end

  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver" 
      task t, :roles => :app do
        #invoke_command checks the use_sudo 
        #variable to determine how to run 
        # the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method
      end
    end
  end
end

namespace :solr do

  task :start, :roles => :app do
   run "cd #{latest_release} && #{rake} solr:start RAILS_ENV=production 2>/dev/null"
  end

  task :stop, :roles => :app do
   run "cd #{latest_release} && #{rake} solr:stop RAILS_ENV=production 2>/dev/null"
  end

  task :restart, :roles => :app do
   solr.stop
   solr.start
  end
end




