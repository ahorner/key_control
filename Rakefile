require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc "Bring up Vagrant VM for testing"
task "vagrant:up" do
  # `unset` call due to https://github.com/mitchellh/vagrant/issues/3193
  system("unset RUBYLIB RUBYOPT; vagrant up")
end


task :default do
  if RUBY_PLATFORM =~ /linux/
    Rake::Task['test'].invoke
  else
    Rake::Task['vagrant:up'].invoke
    # `unset` call due to https://github.com/mitchellh/vagrant/issues/3193
    system("unset RUBYLIB RUBYOPT; vagrant ssh -c 'cd /vagrant && bundle && rake test'")
  end
end
