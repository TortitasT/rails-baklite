class BakliteGenerator < Rails::Generators::Base
  desc 'This generator creates an initializer file at config/initializers/baklite.rb'
  def create_initializer_file
    create_file 'config/initializers/baklite.rb', <<~RUBY
      Rails::Baklite.configure do |config|
        config.token = Rails.application.credentials.baklite[:token]
        config.name = Rails.application.class.module_parent_name
      end
    RUBY
  end
end
