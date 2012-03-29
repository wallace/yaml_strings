# This class ensures that all rake tasks are loaded in a Rails 3 app
require 'rails'
class LoadRakeTask < Rails::Railtie
  railtie_name :yaml_string
  rake_tasks do
    Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |f| load f }
  end
end
