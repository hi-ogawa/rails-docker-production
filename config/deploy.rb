lock '3.6.1'

REQUIRED_FILES = [ 'docker-compose.run.yml', 'env.rails', 'env.mysql' ]

namespace :docker_deploy do
  desc 'bootstrap'
  task :bootstrap do
    invoke('docker_deploy:prepare')
    invoke('docker_deploy:check')
    invoke('docker_deploy:push_image')
    invoke('docker_deploy:compose', 'pull mysql')
    invoke('docker_deploy:compose', 'up -d')
    sleep 10 # wait for mysql is ready
    invoke('docker_deploy:compose', 'exec rails bundle exec rake db:migrate')
  end

  desc 'update'
  task :update do
    invoke('docker_deploy:push_image')
    invoke('docker_deploy:compose', 'up -d rails')
    invoke('docker_deploy:compose', 'exec rails bundle exec rake db:migrate')
  end

  desc 'push image'
  task :push_image do
    on roles(:all) do
      upload!('./scripts/deployment/image.tar', '/home/ubuntu/image.tar')
      execute('docker load -i /home/ubuntu/image.tar')
    end
  end

  desc 'compose'
  task :compose, [:cmd] do|tsk, args|
    invoke('docker_deploy:check')
    on roles(:all) do
      execute("cd /home/ubuntu/app && docker-compose -f docker-compose.run.yml #{args[:cmd]}")
    end
    tsk.reenable
  end

  desc 'prepare'
  task :prepare do
    on roles(:all) do
      execute('mkdir -p /home/ubuntu/app')
      REQUIRED_FILES.each do |file|
        upload!("scripts/deployment/#{file}", "/home/ubuntu/app/#{file}")
      end
    end
  end

  desc 'check'
  task :check do |tsk|
    on roles(:all) do
      execute('echo "check if required executables exist"')
      raise "command 'docker' not found" unless test('type docker')
      raise "command 'docker-compose' not found" unless test('type docker-compose')
      execute('echo "check if required files exist"')
      REQUIRED_FILES.each do |file|
        unless test("[ -f /home/ubuntu/app/#{file} ]")
          raise "#{file} doens't exist."
        end
      end
    end
    tsk.reenable
  end
end
