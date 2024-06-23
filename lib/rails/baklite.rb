require 'rails/baklite/version'
require 'rails/baklite/railtie'
require 'sqlite3'

module Rails
  module Baklite
    def self.backup
      db_config = ActiveRecord::Base.connection_db_config
      database = db_config.configuration_hash
      raise Error, 'Only SQLite3 databases are supported' if database[:adapter] != 'sqlite3'

      backupfile = "#{Rails.root}/tmp/database.bak"

      _backup(ActiveRecord::Base.connection.raw_connection, backupfile)

      backupfile
    end

    def self._backup(sdb, backupfile, name = 'main')
      ddb = SQLite3::Database.new(backupfile)

      b = SQLite3::Backup.new(ddb, name, sdb, name)
      p [b.remaining, b.pagecount]
      begin
        p b.step(1)
        p [b.remaining, b.pagecount]
      end while b.remaining > 0
      b.finish

      ddb = SQLite3::Database.new(backupfile)
      b = SQLite3::Backup.new(ddb, name, sdb, name)
      b.step(-1)
      b.finish
    end

    def self.restore(backupfile, sdb, name = 'main')
      ddb = SQLite3::Database.new(backupfile, readonly: true)

      b = SQLite3::Backup.new(sdb, name, ddb, name)
      begin
        b.step(1)
      end while b.remaining > 0
      b.finish
    end
  end
end
