node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd current_path
    user deploy[:user]
    command 'bundle exec rake assets:precompile'
    notifies :run, resources(:execute =>"restart Rails app #{application} for custom env after precompile") 
    environment 'RAILS_ENV' => rails_env
  end

end