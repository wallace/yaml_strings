# This class ensures that all rake tasks are loaded in a Rails 3 app
if defined?(Rails)
  class LoadRakeTask < Rails::Railtie
    railtie_name :yaml_strings
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |f| load f }
    end
  end
end
