require 'fileutils'

desc "Deploy the updated codebase"
task :deploy do
  deploy_branch    = ENV["DEPLOY_BRANCH"]
  repo_path        = ENV["REPO_PATH"]
  deployed_path    = ENV["DEPLOYED_PATH"]
  private_key_path = ENV["PRIVATE_KEY_PATH"]

  FileUtils.cd(repo_path)
  system("eval $(ssh-agent -s); ssh-add #{private_key_path}; git fetch origin #{deploy_branch}")
  system("git checkout -f origin/#{deploy_branch}")
  system("bundle")
  system("bundle exec rake db:migrate")
  FileUtils.touch(deployed_path)
end
