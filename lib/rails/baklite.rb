require 'rails/baklite/version'
require 'rails/baklite/railtie'
require 'sqlite3'
require 'net/http'
require 'active_support/configurable'

module Rails
  module Baklite
    include ActiveSupport::Configurable

    class Error < StandardError; end

    config_accessor(:token) do
      ''
    end

    def self.backup
      db_config = ActiveRecord::Base.connection_db_config
      database = db_config.configuration_hash
      raise Error, 'Only SQLite3 databases are supported' if database[:adapter] != 'sqlite3'

      backupfile = "#{Rails.root}/tmp/database.bak"

      _backup(ActiveRecord::Base.connection.raw_connection, backupfile)

      upload(backupfile)

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

    def self.upload(backupfile)
      raise Error, 'No token provided' if Rails::Baklite.token.empty?

      name = Rails::Baklite.config.name || Rails.application.class.module_parent_name
      addr = Rails.env.test? ? 'http://localhost:3000' : 'https://baklite.tortitas.eu'

      uri = URI.parse("#{addr}/databases/snapshots")

      File.open(backupfile) do |file|
        req = Net::HTTP::Post.new(uri.path)

        req['Authorization'] =
          "Bearer #{Rails::Baklite.token}"
        req.set_form [['file', file], ['name', name]], 'multipart/form-data'

        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          if !Rails.env.test?
            http.use_ssl = true
          end

          http.request(req)
        end

        raise Error, "Failed to upload the backup: #{res.code} #{res.body}" if res.code != '201'
      end
    end
  end
end
