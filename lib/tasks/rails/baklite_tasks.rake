# desc "Explaining what the task does"
# task :rails_baklite do
#   # Task goes here
# end

desc 'Backup the SQLite3 database'
task backup: [:environment] do |_t|
  Rails::Baklite.backup
end
