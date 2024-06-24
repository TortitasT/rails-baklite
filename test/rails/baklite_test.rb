require 'test_helper'

def test_files_path
  dirname = File.dirname("#{Rails.root}/tmp/test_files")
  FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

  dirname
end

def create_sample_db(db_name)
  puts "Creating sample db: #{db_name}"
  db = SQLite3::Database.new(db_name)
  db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS test(
          id INTEGER NOT NULL PRIMARY KEY,
          test TEXT
        )
  SQL

  db.execute 'DELETE FROM test'
  db.execute 'INSERT INTO test (test) VALUES (?), (?)', %w[test1 test2]
end

def delete_files(files)
  files.each do |f|
    f = File.open(f, 'r')
  ensure
    if !f.nil? && File.exist?(f)
      f.close unless f.closed?
      File.delete(f)
    end
  end
end

class Rails::BakliteTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  test 'it has a version number' do
    assert Rails::Baklite::VERSION
  end

  test 'it does the backup when configured in rails' do
    Post.delete_all
    Post.create(title: 'Hello', body: 'World')

    Rails::Baklite.backup

    assert File.exist?("#{Rails.root}/tmp/database.bak")

    db = SQLite3::Database.new("#{Rails.root}/tmp/database.bak")
    rows = db.execute('SELECT * FROM posts')
    assert_equal 1, rows.length
    assert_equal 'Hello', rows[0][1]
  end

  test 'it does the backup' do
    db_name = "#{test_files_path}/test.sqlite"
    backup_name = "#{test_files_path}/backup.sqlite"

    create_sample_db(db_name)

    Rails::Baklite._backup(
      SQLite3::Database.new(db_name),
      backup_name
    )

    db = SQLite3::Database.new(backup_name)
    rows = db.execute('SELECT * FROM test')
    assert_equal 2, rows.length

    delete_files [db_name, backup_name]
  end

  test 'it does the restore' do
    db_name = "#{test_files_path}/test.sqlite"
    backup_name = "#{test_files_path}/backup.sqlite"

    create_sample_db(db_name)

    Rails::Baklite._backup(
      SQLite3::Database.new(db_name),
      backup_name
    )
    delete_files [db_name]

    Rails::Baklite.restore(
      backup_name,
      SQLite3::Database.new(db_name)
    )

    db = SQLite3::Database.new(db_name)
    rows = db.execute('SELECT * FROM test')
    assert_equal 2, rows.length

    delete_files [db_name, backup_name]
  end

  test 'it does the upload' do
    db_name = "#{test_files_path}/test.sqlite"
    backup_name = "#{test_files_path}/backup.sqlite"

    create_sample_db(db_name)

    Rails::Baklite._backup(
      SQLite3::Database.new(db_name),
      backup_name
    )

    Rails::Baklite.upload(backup_name)

    delete_files [db_name, backup_name]
  end
end
