Rails::Baklite.configure do |config|
  config.token = Rails.application.credentials.baklite[:token]
  config.name = Rails.application.class.module_parent_name
end
